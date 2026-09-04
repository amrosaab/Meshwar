import 'dart:ui';
import 'package:flutter/material.dart';

import '../../common/common.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class CustomLoader {
  // Tracks the loader's own route directly, instead of a boolean flag.
  // dismiss() removes exactly this route via NavigatorState.removeRoute,
  // which works no matter what else has been pushed on top since —
  // unlike Navigator.pop(), which only ever affects the topmost route.
  static Route<dynamic>? _route;

  static Future loader(BuildContext context) async {
    final navigatorState = navigatorKey.currentState;
    if (navigatorState == null) {
      return Future.value();
    }
    if (_route != null) {
      // Already showing — don't stack a second one on top of itself.
      return Future.value();
    }

    final route = DialogRoute<dynamic>(
      context: navigatorState.context,
      barrierColor: Colors.black.withOpacity(0.4),
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.surfaceBorder(context)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.meshwarRed.withOpacity(0.22),
                      blurRadius: 24,
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: const Loader(),
              ),
            ),
          ),
        );
      },
    );

    _route = route;

    // Covers the barrier-tap dismiss path too: whenever this specific
    // route actually finishes (however it was removed), clear the
    // reference — but only if it's still the route we think is showing,
    // in case dismiss() already cleared it and a new one has since
    // started.
    navigatorState.push(route).whenComplete(() {
      if (identical(_route, route)) {
        _route = null;
      }
    });

    return Future.value();
  }

  static void dismiss(BuildContext context) {
    final route = _route;
    if (route == null) return;
    _route = null;
    if (route.isActive) {
      navigatorKey.currentState?.removeRoute(route);
    }
  }
}

class Loader extends StatefulWidget {
  final Color? color;
  const Loader({super.key, this.color});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with TickerProviderStateMixin {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.6,
        color: widget.color ?? AppColors.primary,
      ),
    );
  }
}