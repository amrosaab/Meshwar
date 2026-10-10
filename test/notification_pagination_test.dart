import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/core/network/failure.dart';
import 'package:meshwar_user/di/locator.dart';
import 'package:meshwar_user/features/account/application/acc_bloc.dart';
import 'package:meshwar_user/features/account/application/usecase/acc_usecases.dart';
import 'package:meshwar_user/features/account/domain/models/notifications_model.dart';

class ControlledNotifications extends Fake implements AccUsecase {
  final requests =
      <String, Completer<Either<Failure, NotificationResponseModel>>>{};
  @override
  Future<Either<Failure, NotificationResponseModel>> notificationDetails(
      {String? pageNo}) {
    final request = Completer<Either<Failure, NotificationResponseModel>>();
    requests[pageNo!] = request;
    return request.future;
  }
}

NotificationResponseModel response(int page, List<String> ids) =>
    NotificationResponseModel(
        success: true,
        message: '',
        data: ids
            .map((id) => NotificationData(
                id: id,
                title: id,
                body: '',
                image: null,
                convertedCreatedAt: ''))
            .toList(),
        meta: NotificationPagination(
            pagination: Pagination(
                total: 4,
                count: ids.length,
                perPage: 2,
                currentPage: page,
                totalPages: 2,
                links: null)));

void main() {
  testWidgets(
      'Notifications deduplicate pages, replace refresh, and recover after exceptions',
      (tester) async {
    final usecase = ControlledNotifications();
    serviceLocator.registerSingleton<AccUsecase>(usecase);
    final bloc = AccBloc();
    addTearDown(() async {
      await bloc.close();
      await serviceLocator.unregister<AccUsecase>();
    });
    bloc.add(NotificationGetEvent());
    await tester.pump();
    expect(usecase.requests.keys, ['1']);
    usecase.requests['1']!.complete(Right(response(1, ['a', 'b'])));
    await tester.pump();
    bloc.add(NotificationGetEvent(pageNumber: 2));
    await tester.pump();
    usecase.requests['2']!.complete(Right(response(2, ['b', 'c'])));
    await tester.pump();
    expect(bloc.notificationDatas.map((item) => item.id), ['a', 'b', 'c']);
    bloc.add(NotificationGetEvent());
    await tester.pump();
    usecase.requests['1']!.complete(Right(response(1, ['b', 'c'])));
    await tester.pump();
    expect(bloc.notificationDatas.map((item) => item.id), ['b', 'c']);
    bloc.add(NotificationGetEvent(pageNumber: 2));
    await tester.pump();
    usecase.requests['2']!
        .completeError(Exception('Temporary connection failure'));
    await tester.pump();
    expect(bloc.isLoading, isFalse);
    expect(bloc.state, isA<NotificationFailure>());
    expect(bloc.notificationDatas.map((item) => item.id), ['b', 'c']);
    bloc.add(NotificationGetEvent(pageNumber: 2));
    await tester.pump();
    usecase.requests['2']!.complete(Right(response(2, ['d'])));
    await tester.pump();
    expect(bloc.notificationDatas.map((item) => item.id), ['b', 'c', 'd']);
    expect(bloc.isLoading, isFalse);
  });
}
