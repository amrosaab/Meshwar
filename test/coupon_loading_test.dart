import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/core/network/failure.dart';
import 'package:meshwar_user/di/locator.dart';
import 'package:meshwar_user/features/account/application/acc_bloc.dart';
import 'package:meshwar_user/features/account/application/usecase/acc_usecases.dart';
import 'package:meshwar_user/features/account/domain/models/promo_code_clear_model.dart';
import 'package:meshwar_user/features/bookingpage/domain/models/promo_code_list_model.dart';

class ControlledCoupons extends Fake implements AccUsecase {
  final lists = <Completer<Either<Failure, PromoCodeListModel>>>[];
  final applies = <Completer<Either<Failure, dynamic>>>[];
  final clears = <Completer<Either<Failure, PromoCodeClearModel>>>[];
  @override
  Future<Either<Failure, PromoCodeClearModel>> promoCodeClear() {
    final request = Completer<Either<Failure, PromoCodeClearModel>>();
    clears.add(request);
    return request.future;
  }

  @override
  Future<Either<Failure, PromoCodeListModel>> getPromoCodeList() {
    final request = Completer<Either<Failure, PromoCodeListModel>>();
    lists.add(request);
    return request.future;
  }

  @override
  Future<Either<Failure, dynamic>> promoCodeRedeem({required String code}) {
    final request = Completer<Either<Failure, dynamic>>();
    applies.add(request);
    return request.future;
  }
}

void main() {
  testWidgets(
      'Coupons recover after failed loading and prevent repeated apply requests',
      (tester) async {
    final usecase = ControlledCoupons();
    serviceLocator.registerSingleton<AccUsecase>(usecase);
    final bloc = AccBloc();
    addTearDown(() async {
      await bloc.close();
      await serviceLocator.unregister<AccUsecase>();
    });
    bloc.add(GetPromoCodeListEvent());
    await tester.pump();
    expect(bloc.isLoading, isTrue);
    usecase.lists.single.completeError(Exception('Temporary network failure'));
    await tester.pump();
    expect(bloc.isLoading, isFalse);
    expect(bloc.isPromoListLoading, isFalse);
    bloc.add(GetPromoCodeListEvent());
    await tester.pump();
    usecase.lists.last.complete(
        Right(PromoCodeListModel(success: true, message: '', data: [])));
    await tester.pump();
    bloc.add(
        SelectPromoCodeListApplyEvent(selectedPromoCode: 'SAVE', price: '30'));
    await tester.pump();
    expect(bloc.isPromoChanging, isTrue);
    bloc.add(
        SelectPromoCodeListApplyEvent(selectedPromoCode: 'SAVE', price: '30'));
    await tester.pump();
    expect(usecase.applies, hasLength(1));
    usecase.applies.single.completeError(Exception('Temporary apply failure'));
    await tester.pump();
    expect(bloc.isPromoChanging, isFalse);
    expect(bloc.state, isA<PromoApplyFailureState>());
    bloc.add(
        SelectPromoCodeListApplyEvent(selectedPromoCode: 'SAVE', price: '30'));
    await tester.pump();
    usecase.applies.last.complete(const Right(true));
    await tester.pump();
    expect(bloc.isPromoChanging, isFalse);
    expect(bloc.selectedPromoCodeValue, 'SAVE');
    expect(bloc.selectedPromoPrice, '30');
    expect(bloc.state, isA<PromoApplySuccessState>());
    bloc.add(PromoCodeClearEvent(from: '2'));
    await tester.pump();
    bloc.add(PromoCodeClearEvent(from: '2'));
    await tester.pump();
    expect(usecase.clears, hasLength(1));
    usecase.clears.single.completeError(Exception('Temporary remove failure'));
    await tester.pump();
    expect(bloc.isPromoChanging, isFalse);
    expect(bloc.isLoading, isFalse);
    expect(bloc.state, isA<PromoClearFailureState>());
  });
}
