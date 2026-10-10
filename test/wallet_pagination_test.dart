import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/core/network/failure.dart';
import 'package:meshwar_user/di/locator.dart';
import 'package:meshwar_user/features/account/application/acc_bloc.dart';
import 'package:meshwar_user/features/account/application/usecase/acc_usecases.dart';
import 'package:meshwar_user/features/account/domain/models/walletpage_model.dart';

class ControlledWalletUsecase extends Fake implements AccUsecase {
  final requests = <int, Completer<Either<Failure, WalletResponseModel>>>{};
  @override
  Future<Either<Failure, WalletResponseModel>> getWalletDetail(int page) {
    final request = Completer<Either<Failure, WalletResponseModel>>();
    requests[page] = request;
    return request.future;
  }
}

void main() {
  testWidgets(
      'Wallet pagination tolerates empty metadata and recovers after failure',
      (tester) async {
    final usecase = ControlledWalletUsecase();
    serviceLocator.registerSingleton<AccUsecase>(usecase);
    final bloc = AccBloc();
    addTearDown(() async {
      await bloc.close();
      await serviceLocator.unregister<AccUsecase>();
    });
    expect(bloc.walletPageScrollListener, returnsNormally);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ListView(
                controller: bloc.scrollController,
                children: const [SizedBox(height: 1200)]))));
    bloc.isLoading = false;
    // Empty responses and first-load failures have no pagination object.
    bloc.walletPageScrollListener();
    expect(usecase.requests, isEmpty);
    bloc.walletPaginations = WalletPagination(
        pagination: Pagination(
            total: 2,
            count: 1,
            perPage: 1,
            currentPage: 1,
            totalPages: 2,
            links: null));
    bloc.scrollController
        .jumpTo(bloc.scrollController.position.maxScrollExtent);
    bloc.walletPageScrollListener();
    await tester.pump();
    expect(usecase.requests.keys, [2]);
    expect(bloc.loadMore, isTrue);
    expect(bloc.isLoading, isTrue);
    usecase.requests[2]!
        .complete(Left(GetDataFailure(message: 'Temporary network error')));
    await tester.pump();
    expect(bloc.loadMore, isFalse);
    expect(bloc.isLoading, isFalse);
    // The user can try the next page again after a failed request.
    bloc.walletPageScrollListener();
    await tester.pump();
    final response = WalletResponseModel.fromJson(
        {'wallet_balance': '30.00', 'currency_symbol': '£'});
    response.walletHistory = WalletHistory(
        data: [
          WalletHistoryData.fromJson({
            'id': 'transaction-2',
            'amount': 10,
            'is_credit': 1,
            'currency_symbol': '£',
            'remarks': 'Money Deposited',
          })
        ],
        meta: WalletPagination(
            pagination: Pagination(
                total: 2,
                count: 1,
                perPage: 1,
                currentPage: 2,
                totalPages: 2,
                links: null)));
    usecase.requests[2]!.complete(Right(response));
    await tester.pump();
    expect(bloc.walletHistoryList.single.id, 'transaction-2');
    expect(bloc.walletResponse!.walletBalance, '30.00');
    expect(bloc.loadMore, isFalse);
    expect(bloc.walletPageScrollListener, returnsNormally);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
