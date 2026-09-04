import '../core/network/network.dart';
import '../core/services/services.dart';
import 'package:get_it/get_it.dart';

import '../features/auth/application/auth_bloc.dart';
import '../features/auth/application/usecases/auth_usecase.dart';
import '../features/auth/data/repo_implementation/auth_repo_impl.dart';
import '../features/auth/data/repository/auth_api.dart';
import '../features/auth/domain/repositories/auth_repo.dart';
import '../features/bookingpage/application/booking_bloc.dart';
import '../features/bookingpage/application/usecases/booking_usecase.dart';
import '../features/bookingpage/data/repository/booking_api.dart';
import '../features/bookingpage/data/repo_implementation/booking_repo_impl.dart';
import '../features/bookingpage/domain/repositories/booking_repo.dart';
import '../features/home/application/home_bloc.dart';
import '../features/home/data/repository/home_api.dart';
import '../features/home/data/repo_implementation/home_repo_impl.dart';
import '../features/home/domain/repositories/home_repo.dart';
import '../features/home/application/usecase/home_usecases.dart';
import '../features/landing/application/onboarding_bloc.dart';
import '../features/landing/data/repository/onboarding_api.dart';
import '../features/landing/data/repo_implementation/onboarding_repo_impl.dart';
import '../features/landing/domain/repositories/onboarding_repo.dart';
import '../features/landing/application/usecase/onboarding_usecase.dart';
import '../features/language/application/language_bloc.dart';
import '../app/localization.dart';
import '../features/language/data/repository/language_api.dart';
import '../features/language/data/repo_implemention/language_list_repo_impl.dart';
import '../features/language/domain/repositories/language_list_repo.dart';
import '../features/language/application/usecases/language_usecase.dart';

// Add the necessary imports for Acc features
import '../features/account/application/acc_bloc.dart';
import '../features/account/application/usecase/acc_usecases.dart';
import '../features/account/data/repository/acc_api.dart';
import '../features/account/data/repo_implementation/acc_repo_impl.dart';
import '../features/account/domain/repositories/acc_repo.dart';
import '../features/loading/application/loader_bloc.dart';
import '../features/loading/application/usecase/loader_usecases.dart';
import '../features/loading/data/repo_implementation/loader_repo_impl.dart';
import '../features/loading/data/repository/loader_api.dart';
import '../features/loading/domain/repositories/loader_repo.dart';

// Userprofile (documents)
import '../features/userprofile/application/usecases/driver_profile_usecase.dart';
import '../features/userprofile/data/repo_implementation/driver_profile_repo_impl.dart';
import '../features/userprofile/data/repository/driver_profile_api.dart';
import '../features/userprofile/domain/repositories/driver_profile_repo.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  serviceLocator
    ..registerSingleton<ApiManager>(DioProviderImpl())
    ..registerSingleton<NavigationService>(NavigationService());

  // LoaderData
  serviceLocator.registerFactory<LoaderBloc>(() => LoaderBloc());
  serviceLocator.registerLazySingleton<LoaderApi>(() => LoaderApi());
  serviceLocator.registerLazySingleton<LoaderRepository>(
      () => LoaderRepositoryImpl(serviceLocator()));
  serviceLocator.registerLazySingleton<LoaderUsecase>(
      () => LoaderUsecase(serviceLocator()));

  // OnBoardingData
  serviceLocator.registerFactory<OnBoardingBloc>(() => OnBoardingBloc());
  serviceLocator.registerLazySingleton<OnBoardingApi>(() => OnBoardingApi());
  serviceLocator.registerLazySingleton<OnBoardingRepository>(
      () => OnBoardingRepositoryImpl(serviceLocator()));
  serviceLocator.registerLazySingleton<OnBoardingUsecase>(
      () => OnBoardingUsecase(serviceLocator()));

  // Localization
  serviceLocator.registerFactory<LocalizationBloc>(() => LocalizationBloc());

  // Language
  serviceLocator.registerFactory<LanguageBloc>(() => LanguageBloc());
  serviceLocator.registerLazySingleton<LanguageApi>(() => LanguageApi());
  serviceLocator.registerLazySingleton<LanguageRepository>(
      () => LanguageRepositoryImpl(serviceLocator()));
  serviceLocator.registerLazySingleton<LanguageUsecase>(
      () => LanguageUsecase(serviceLocator()));

  // Auth
  serviceLocator.registerFactory<AuthBloc>(() => AuthBloc());
  serviceLocator.registerLazySingleton<AuthApi>(() => AuthApi());
  serviceLocator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()));
  serviceLocator
      .registerLazySingleton<AuthUsecase>(() => AuthUsecase(serviceLocator()));

  // Home
  serviceLocator.registerFactory<HomeBloc>(() => HomeBloc());
  serviceLocator.registerLazySingleton<HomeApi>(() => HomeApi());
  serviceLocator.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(serviceLocator()));
  serviceLocator
      .registerLazySingleton<HomeUsecase>(() => HomeUsecase(serviceLocator()));

  // Booking
  serviceLocator.registerFactory<BookingBloc>(() => BookingBloc());
  serviceLocator.registerLazySingleton<BookingApi>(() => BookingApi());
  serviceLocator.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(serviceLocator()));
  serviceLocator.registerLazySingleton<BookingUsecase>(
      () => BookingUsecase(serviceLocator()));

  // Account
  serviceLocator.registerFactory<AccBloc>(() => AccBloc());
  serviceLocator.registerLazySingleton<AccApi>(() => AccApi());
  serviceLocator.registerLazySingleton<AccRepository>(
      () => AccRepositoryImpl(serviceLocator()));
  serviceLocator
      .registerLazySingleton<AccUsecase>(() => AccUsecase(serviceLocator()));

  // Userprofile (documents)
  serviceLocator
      .registerLazySingleton<DriverProfileApi>(() => DriverProfileApi());
  serviceLocator.registerLazySingleton<DriverProfileRepository>(
      () => DriverProfileRepositoryImpl(serviceLocator()));
  serviceLocator.registerLazySingleton<DriverProfileUsecase>(
      () => DriverProfileUsecase(serviceLocator()));
}
