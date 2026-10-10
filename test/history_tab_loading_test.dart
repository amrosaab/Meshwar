import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/core/network/failure.dart';
import 'package:meshwar_user/di/locator.dart';
import 'package:meshwar_user/features/account/application/acc_bloc.dart';
import 'package:meshwar_user/features/account/application/usecase/acc_usecases.dart';
import 'package:meshwar_user/features/account/domain/models/history_model.dart';

class ControlledHistoryUsecase extends Fake implements AccUsecase {
  final requests =
      <String, List<Completer<Either<Failure, HistoryResponseModel>>>>{};

  @override
  Future<Either<Failure, HistoryResponseModel>> historyDetails(String filter,
      {String? pageNo}) {
    final request = Completer<Either<Failure, HistoryResponseModel>>();
    requests.putIfAbsent('$filter:$pageNo', () => []).add(request);
    return request.future;
  }
}

HistoryResponseModel response(String id, {int page = 1, int pages = 3}) =>
    HistoryResponseModel(
      success: true,
      message: 'success',
      data: [
        HistoryData.fromJson({
          'id': id,
          'show_otp_feature': false,
          'completed_ride': true,
          'later_ride': false,
          'cancelled_ride': false,
          'ongoing_ride': false,
          'support_ticket_exists': false,
          'requestProofs': {'data': <dynamic>[]},
        })
      ],
      meta: HistoryPagination(
          pagination: Pagination(
              total: pages,
              count: 1,
              perPage: 1,
              currentPage: page,
              totalPages: pages,
              links: null)),
    );

void main() {
  testWidgets(
      'Outstation results and pagination stay separate from cancelled history',
      (tester) async {
    final usecase = ControlledHistoryUsecase();
    serviceLocator.registerSingleton<AccUsecase>(usecase);
    final bloc = AccBloc();
    addTearDown(() async {
      await bloc.close();
      await serviceLocator.unregister<AccUsecase>();
    });
    bloc.add(HistoryGetEvent(historyFilter: 'out_station=1', pageNumber: 1));
    await tester.pump();
    expect(bloc.isLoading, isTrue);
    usecase.requests['out_station=1:1']!.last
        .complete(Right(response('outstation-1', pages: 2)));
    await tester.pump();
    expect(bloc.historyList.single.id, 'outstation-1');
    expect(bloc.isLoading, isFalse);
    bloc.add(HistoryGetEvent(historyFilter: 'out_station=1', pageNumber: 2));
    await tester.pump();
    usecase.requests['out_station=1:2']!.last
        .complete(Right(response('outstation-2', page: 2, pages: 2)));
    await tester.pump();
    expect(bloc.historyList.map((ride) => ride.id),
        ['outstation-1', 'outstation-2']);
    expect(bloc.historyPaginations!.pagination.currentPage, 2);
    expect(bloc.loadMore, isFalse);
    // Restoring the dedicated cache must not reuse a city history category.
    bloc.add(HistoryGetEvent(historyFilter: 'out_station=1'));
    await tester.pump();
    expect(bloc.historyList.map((ride) => ride.id),
        ['outstation-1', 'outstation-2']);
  });

  test('Fast tab changes keep cached rides and ignore stale responses',
      () async {
    final usecase = ControlledHistoryUsecase();
    serviceLocator.registerSingleton<AccUsecase>(usecase);
    final bloc = AccBloc();
    // A newly selected tab may not have a scroll position or pagination yet.
    expect(bloc.historyPageScrollListener, returnsNormally);
    final states = <AccState>[];
    final subscription = bloc.stream.listen(states.add);
    addTearDown(() async {
      await subscription.cancel();
      await bloc.close();
      await serviceLocator.unregister<AccUsecase>();
    });

    Future<void> select(int index) async {
      final changed =
          bloc.stream.firstWhere((_) => bloc.selectedHistoryType == index);
      bloc.add(HistoryTypeChangeEvent(historyTypeIndex: index));
      await changed;
      await Future<void>.delayed(Duration.zero);
    }

    Future<void> finish(String key, HistoryResponseModel result) async {
      final done =
          bloc.stream.firstWhere((state) => state is HistoryDataSuccessState);
      usecase.requests[key]!.last.complete(Right(result));
      await done;
    }

    final started = bloc.stream.firstWhere((_) => bloc.isLoading);
    bloc.add(HistoryGetEvent(historyFilter: 'is_completed=1'));
    await started;
    await select(1);
    expect(usecase.requests['is_later=1:null'], hasLength(1));
    await finish('is_later=1:null', response('upcoming', pages: 1));
    expect(bloc.historyList.single.id, 'upcoming');

    // The older completed request finishes after the upcoming tab is visible.
    usecase.requests['is_completed=1:null']!.single
        .complete(Right(response('completed')));
    await Future<void>.delayed(Duration.zero);
    expect(bloc.historyList.single.id, 'upcoming');

    await select(0);
    expect(bloc.historyList.single.id, 'completed');
    expect(bloc.historyPaginations!.pagination.totalPages, 3);
    expect(bloc.isLoading, isFalse);
    expect(bloc.firstLoad, isFalse);

    await select(2);
    expect(usecase.requests['is_cancelled=1:null'], hasLength(1));
    await select(0);
    usecase.requests['is_cancelled=1:null']!.single
        .complete(Right(response('cancelled', pages: 2)));
    await Future<void>.delayed(Duration.zero);
    expect(bloc.historyList.single.id, 'completed');
    await select(2);
    expect(bloc.historyList.single.id, 'cancelled');
    expect(bloc.historyPaginations!.pagination.totalPages, 2);
    expect(bloc.isLoading, isFalse);

    final moreStarted = bloc.stream.firstWhere((_) => bloc.loadMore);
    bloc.add(HistoryGetEvent(historyFilter: 'is_cancelled=1', pageNumber: 2));
    await moreStarted;
    await finish(
        'is_cancelled=1:2', response('cancelled-page-2', page: 2, pages: 2));
    expect(bloc.historyList.map((ride) => ride.id),
        ['cancelled', 'cancelled-page-2']);
    expect(bloc.historyPaginations!.pagination.currentPage, 2);
    expect(bloc.loadMore, isFalse);
    expect(states.whereType<HistoryDataLoadingState>(), isEmpty);
  });
}
