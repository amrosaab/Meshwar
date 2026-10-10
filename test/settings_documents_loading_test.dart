import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshwar_user/core/network/failure.dart';
import 'package:meshwar_user/di/locator.dart';
import 'package:meshwar_user/features/account/application/acc_bloc.dart';
import 'package:meshwar_user/features/account/application/usecase/acc_usecases.dart';
import 'package:meshwar_user/features/account/domain/models/faq_model.dart';

class ControlledDocuments extends Fake implements AccUsecase {
  final faqs = <Completer<Either<Failure, FaqResponseModel>>>[];
  final policies = <Completer<Either<Failure, dynamic>>>[];
  @override
  Future<Either<Failure, FaqResponseModel>> getFaqDetail() {
    final request = Completer<Either<Failure, FaqResponseModel>>();
    faqs.add(request);
    return request.future;
  }

  @override
  Future<Either<Failure, dynamic>> getTermsAndPrivacyHtml(
      {required bool isPrivacyPage}) {
    final request = Completer<Either<Failure, dynamic>>();
    policies.add(request);
    return request.future;
  }
}

void main() {
  testWidgets('Settings documents recover after failures and FAQ can collapse',
      (tester) async {
    final api = ControlledDocuments();
    serviceLocator.registerSingleton<AccUsecase>(api);
    final bloc = AccBloc();
    addTearDown(() async {
      await bloc.close();
      await serviceLocator.unregister<AccUsecase>();
    });
    bloc.add(GetFaqListEvent());
    await tester.pump();
    bloc.add(GetFaqListEvent());
    await tester.pump();
    expect(api.faqs, hasLength(1));
    api.faqs.single.completeError(Exception('Temporary failure'));
    await tester.pump();
    expect(bloc.isFaqLoading, isFalse);
    expect(bloc.state, isA<FaqFailureState>());
    bloc.add(GetFaqListEvent());
    await tester.pump();
    api.faqs.last.complete(Right(FaqResponseModel(
        success: true,
        message: '',
        data: [
          FaqData(
              id: 'faq',
              serviceLocationId: '',
              question: 'Question',
              answer: 'Full answer',
              userType: 'user',
              active: true)
        ],
        meta: Meta(
            pagination: Pagination(
                total: 1,
                count: 1,
                perPage: 10,
                currentPage: 1,
                totalPages: 1,
                links: Links())))));
    await tester.pump();
    expect(bloc.faqDataList.single.answer, 'Full answer');
    bloc.add(FaqOnTapEvent(selectedFaqIndex: 0));
    await tester.pump();
    expect(bloc.choosenFaqIndex, -1);
    bloc.add(FaqOnTapEvent(selectedFaqIndex: 0));
    await tester.pump();
    expect(bloc.choosenFaqIndex, 0);
    bloc.add(GetHtmlStringEvent(isPrivacy: true));
    await tester.pump();
    bloc.add(GetHtmlStringEvent(isPrivacy: true));
    await tester.pump();
    expect(api.policies, hasLength(1));
    api.policies.single.completeError(Exception('Temporary failure'));
    await tester.pump();
    expect(bloc.isHtmlLoading, isFalse);
    expect(bloc.hasHtmlLoadFailed, isTrue);
    bloc.add(GetHtmlStringEvent(isPrivacy: true));
    await tester.pump();
    api.policies.last.complete(
        const Right({'success': true, 'data': '<p>Original policy</p>'}));
    await tester.pump();
    expect(bloc.htmlString, '<p>Original policy</p>');
    expect(bloc.hasHtmlLoadFailed, isFalse);
    bloc.add(GetHtmlStringEvent(isPrivacy: true));
    await tester.pump();
    api.policies.last.completeError(Exception('Temporary failure'));
    await tester.pump();
    expect(bloc.htmlString, '<p>Original policy</p>');
    expect(bloc.isHtmlLoading, isFalse);
  });
}
