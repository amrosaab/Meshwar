import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/core/network/failure.dart';
import 'package:meshwar_user/di/locator.dart';
import 'package:meshwar_user/features/account/application/acc_bloc.dart';
import 'package:meshwar_user/features/account/application/usecase/acc_usecases.dart';
import 'package:meshwar_user/features/account/domain/models/referalhistory_model.dart';

class ControlledReferral extends Fake implements AccUsecase {
  final history = <Completer<Either<Failure, dynamic>>>[];
  final content = <Completer<Either<Failure, dynamic>>>[];
  @override
  Future<Either<Failure, dynamic>> referalHistory() {
    final request = Completer<Either<Failure, dynamic>>();
    history.add(request);
    return request.future;
  }

  @override
  Future<Either<Failure, dynamic>> referalResponse() {
    final request = Completer<Either<Failure, dynamic>>();
    content.add(request);
    return request.future;
  }
}

void main() {
  testWidgets(
      'Referral loads independently, retries after exceptions, and preserves history',
      (tester) async {
    final usecase = ControlledReferral();
    serviceLocator.registerSingleton<AccUsecase>(usecase);
    final bloc = AccBloc();
    addTearDown(() async {
      await bloc.close();
      await serviceLocator.unregister<AccUsecase>();
    });
    bloc.add(ReferalHistoryEvent());
    bloc.add(ReferralResponseEvent());
    await tester.pump();
    expect(bloc.isReferralHistoryLoading, isTrue);
    expect(bloc.isReferralContentLoading, isTrue);
    bloc.add(ReferalHistoryEvent());
    await tester.pump();
    expect(usecase.history, hasLength(1));
    usecase.content.single
        .completeError(Exception('Content temporarily unavailable'));
    await tester.pump();
    expect(bloc.isReferralContentLoading, isFalse);
    expect(bloc.isReferralHistoryLoading, isTrue);
    usecase.history.single.complete(Right(ReferralResponse(
        success: true,
        message: '',
        data: [
          Referral(
              id: 1,
              name: 'Friend',
              profilePicture: '',
              roleName: 'user',
              earning: 30,
              currencySymbol: 'KWD',
              createdAt: '',
              referralStatus: 'pending')
        ],
        meta: Meta(
            pagination: Pagination(
                total: 1,
                count: 1,
                perPage: 10,
                currentPage: 1,
                totalPages: 1,
                links: {})))));
    await tester.pump();
    expect(bloc.hasLoadedReferralHistory, isTrue);
    expect(bloc.isReferralHistoryLoading, isFalse);
    bloc.add(ReferralTabChangeEvent(showReferralHistory: true));
    await tester.pump();
    expect(bloc.referralHistory.single.name, 'Friend');
    bloc.add(ReferalHistoryEvent());
    await tester.pump();
    usecase.history.last.completeError(Exception('Temporary history failure'));
    await tester.pump();
    expect(bloc.referralHistory.single.name, 'Friend');
    expect(bloc.isReferralHistoryLoading, isFalse);
    bloc.add(ReferralResponseEvent());
    await tester.pump();
    expect(usecase.content, hasLength(2));
    usecase.content.last.complete(Left(GetDataFailure(message: 'Try again')));
    await tester.pump();
    expect(bloc.isReferralContentLoading, isFalse);
  });
}
