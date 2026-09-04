// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../common/common.dart';
import '../../../core/utils/custom_snack_bar.dart';
import '../../../di/locator.dart';
import '../../home/application/usecase/home_usecases.dart';
import '../../home/domain/models/user_details_model.dart';
import 'usecase/loader_usecases.dart';

part 'loader_event.dart';
part 'loader_state.dart';

class LoaderBloc extends Bloc<LoaderEvent, LoaderState> {
  LoaderBloc() : super(LoaderInitialState()) {
    on<LoaderGetLocalDataEvent>(loadData);
    on<UpdateUserLocationEvent>(updateUserLocation);
    on<GoogleUpdateUserLocationEvent>(googleUpdateUserLocation);
  }

  Future<void> loadData(
      LoaderGetLocalDataEvent event, Emitter<LoaderState> emit) async {
    final landingStatus = await AppSharedPreference.getLandingStatus();
    final loginStatus = await AppSharedPreference.getLoginStatus();
    final selectedLanguage =
        await AppSharedPreference.getSelectedLanguageCode();

    UserDetail? userData;
    if (loginStatus) {
      final result = await serviceLocator<HomeUsecase>().userDetails();
      result.fold((error) {
        debugPrint('LoaderBloc UserDetails error: $error');
      }, (success) {
        userData = success.data;
      });
    }

    emit(LoaderSuccessState(
        loginStatus: loginStatus,
        landingStatus: landingStatus,
        selectedLanguage: selectedLanguage,
        userData: userData));
  }

  //  Locations
  Future<void> googleUpdateUserLocation(
      GoogleUpdateUserLocationEvent event, Emitter<LoaderState> emit) async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double lat = position.latitude;
      double long = position.longitude;
      final data = await serviceLocator<LoaderUsecase>()
          .updateUserLocation(currentLocation: LatLng(lat, long));
      data.fold((error) {
        debugPrint(error.toString());
      }, (success) {
        debugPrint('location updated');
      });
    } else {
      await Permission.location.request();
      showToast(
          message: 'allow location permission to get your current location');
    }
  }

  Future<void> updateUserLocation(
      UpdateUserLocationEvent event, Emitter<LoaderState> emit) async {
    PermissionStatus permission;
    permission = await Permission.location.status;
    if (permission == PermissionStatus.granted ||
        permission == PermissionStatus.limited) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double lat = position.latitude;
      double long = position.longitude;
      final data = await serviceLocator<LoaderUsecase>()
          .updateUserLocation(currentLocation: LatLng(lat, long));
      data.fold((error) {
        printWrapped("Location Api error ${error.toString()}");
      }, (success) {
        printWrapped("Location Api success");
      });
    }
  }
}
