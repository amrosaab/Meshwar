import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:meshwar_user/l10n/app_localizations.dart';

import '../../common/common.dart';
import 'custom_loader.dart';
import 'custom_text.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();

class ConnectivityService {
  ConnectivityService._internal();

  static final ConnectivityService _instance = ConnectivityService._internal();

  factory ConnectivityService() => _instance;

  final Connectivity _connectivity = Connectivity();
  Connectivity get connectivity => _connectivity;

  void initialize() {
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      // onConnectivityChanged can report multiple simultaneous connection
      // types (e.g. both wifi and mobile active at once), so checking
      // result.first alone is order-dependent and can misreport the real
      // state — checking for actual presence of each type is reliable
      // regardless of list order.
      final hasWifi = result.contains(ConnectivityResult.wifi);
      final hasMobile = result.contains(ConnectivityResult.mobile);
      final isConnected = hasWifi || hasMobile;

      if (isConnected) {
        final message = hasWifi
            ? 'Connected to WiFi'
            : 'Connected to Mobile Network';
        scaffoldMessengerKey.currentState?.clearSnackBars();
        scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.routeGreen,
          duration: const Duration(seconds: 2),
        ));
        _closeDialogIfOpen();
      } else {
        if (navigatorKey.currentContext != null) {
          _showNoConnectionDialog(navigatorKey.currentContext!);
        }
      }
    });
  }

  Future<List<ConnectivityResult>> checkConnectivity() {
    return _connectivity.checkConnectivity();
  }

  void _closeDialogIfOpen() {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop();
    } else {
      printWrapped("No routes to pop.");
    }
  }

  void _showNoConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceStrong(context),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.surfaceBorder(context)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.red.withOpacity(0.15),
                      blurRadius: 30,
                      spreadRadius: -8,
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppImages.noInternet,
                      height: size.height * 0.13,
                      width: size.width * 0.3,
                    ),
                    const SizedBox(height: 14),
                    MyText(
                      text: AppLocalizations.of(context)!.noInternetConnection,
                      textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    MyText(
                      text: AppLocalizations.of(context)!.noInternetCheckContent,
                      textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.hintColor,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}