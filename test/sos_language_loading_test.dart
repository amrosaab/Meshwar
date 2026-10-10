import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meshwar_user/core/network/failure.dart';
import 'package:meshwar_user/di/locator.dart';
import 'package:meshwar_user/features/account/application/acc_bloc.dart';
import 'package:meshwar_user/features/account/application/usecase/acc_usecases.dart';
import 'package:meshwar_user/features/language/application/language_bloc.dart';
import 'package:meshwar_user/features/language/application/usecases/language_usecase.dart';

class ControlledSos extends Fake implements AccUsecase {
  final adds = <Completer<Either<Failure, dynamic>>>[];
  final deletes = <Completer<Either<Failure, dynamic>>>[];
  @override
  Future<Either<Failure, dynamic>> addSosContact(
      {required String name, required String number}) {
    final request = Completer<Either<Failure, dynamic>>();
    adds.add(request);
    return request.future;
  }

  @override
  Future<Either<Failure, dynamic>> deleteSosContact(String id) {
    final request = Completer<Either<Failure, dynamic>>();
    deletes.add(request);
    return request.future;
  }
}

class ControlledLanguages extends Fake implements LanguageUsecase {
  final updates = <Completer<Either<Failure, dynamic>>>[];
  @override
  Future<Either<Failure, dynamic>> updateLanguage(String langCode) {
    final request = Completer<Either<Failure, dynamic>>();
    updates.add(request);
    return request.future;
  }
}

void main() {
  testWidgets('Failed SOS changes release busy state and allow retry',
      (tester) async {
    final api = ControlledSos();
    serviceLocator.registerSingleton<AccUsecase>(api);
    final bloc = AccBloc();
    addTearDown(() async {
      await bloc.close();
      await serviceLocator.unregister<AccUsecase>();
    });
    bloc.add(AddContactEvent(name: 'Test', number: '+96512345678'));
    await tester.pump();
    bloc.add(AddContactEvent(name: 'Test', number: '+96512345678'));
    await tester.pump();
    expect(api.adds, hasLength(1));
    expect(bloc.isLoading, isTrue);
    api.adds.single.completeError(Exception('Temporary failure'));
    await tester.pump();
    expect(bloc.isLoading, isFalse);
    expect(bloc.state, isA<AddContactFailureState>());
    bloc.add(AddContactEvent(name: 'Test', number: '+96512345678'));
    await tester.pump();
    expect(api.adds, hasLength(2));
    api.adds.last.completeError(Exception('Temporary failure'));
    await tester.pump();
    bloc.add(DeleteContactEvent(id: 'test'));
    await tester.pump();
    bloc.add(DeleteContactEvent(id: 'test'));
    await tester.pump();
    expect(api.deletes, hasLength(1));
    api.deletes.single.completeError(Exception('Temporary failure'));
    await tester.pump();
    expect(bloc.isLoading, isFalse);
    expect(bloc.state, isA<SosFailureState>());
  });
  testWidgets(
      'Language initializes saved selection and retries failed confirmation',
      (tester) async {
    SharedPreferences.setMockInitialValues({'choosenLanguage': 'ar'});
    final api = ControlledLanguages();
    serviceLocator.registerSingleton<LanguageUsecase>(api);
    final bloc = LanguageBloc();
    addTearDown(() async {
      await bloc.close();
      await serviceLocator.unregister<LanguageUsecase>();
    });
    bloc.add(LanguageGetEvent(isInitialLanguageChange: false));
    await tester.pumpAndSettle();
    expect(bloc.selectedIndex, 1);
    expect(bloc.choosedLanguage, 'ar');
    bloc.add(LanguageSelectUpdateEvent(selectedLanguage: 'ar'));
    await tester.pump();
    bloc.add(LanguageSelectUpdateEvent(selectedLanguage: 'ar'));
    await tester.pump();
    expect(api.updates, hasLength(1));
    api.updates.single.completeError(Exception('Temporary failure'));
    await tester.pump();
    expect(bloc.isUpdating, isFalse);
    expect(bloc.state, isA<LanguageFailureState>());
    bloc.add(LanguageSelectUpdateEvent(selectedLanguage: 'ar'));
    await tester.pump();
    expect(api.updates, hasLength(2));
    api.updates.last.complete(const Right(true));
    await tester.pumpAndSettle();
    expect(bloc.isUpdating, isFalse);
    expect(bloc.state, isA<LanguageUpdateState>());
  });
}
