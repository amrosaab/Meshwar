import 'package:flutter/material.dart';

/// A softer page transition than Flutter's default slide-from-right:
/// the incoming page fades in while rising slightly, the outgoing page
/// fades out and sinks slightly. Reads as a single continuous motion
/// rather than two pages sliding past each other.
///
/// Usage — anywhere you currently write:
///   Navigator.push(context, MaterialPageRoute(builder: (_) => NextPage()));
/// write instead:
///   Navigator.push(context, fadeSlideRoute(const NextPage()));
///
/// To use with named routes, wrap the returned page in your
/// onGenerateRoutes switch:
///   case NextPage.routeName:
///     return fadeSlideRoute(const NextPage(), settings: settings);
Route<T> fadeSlideRoute<T>(Widget page, {RouteSettings? settings}) {
  return PageRouteBuilder<T>(
    settings: settings,
    transitionDuration: const Duration(milliseconds: 380),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final enterCurve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      final exitCurve = CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic);

      final fadeIn = Tween<double>(begin: 0, end: 1).animate(enterCurve);
      final riseIn = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(enterCurve);
      final fadeOut = Tween<double>(begin: 1, end: 0.4).animate(exitCurve);
      final sinkOut = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.02)).animate(exitCurve);

      return FadeTransition(
        opacity: fadeOut,
        child: SlideTransition(
          position: sinkOut,
          child: FadeTransition(
            opacity: fadeIn,
            child: SlideTransition(position: riseIn, child: child),
          ),
        ),
      );
    },
  );
}

/// Same motion, but for modal-style pushes where you want the incoming
/// page to rise noticeably further, like a sheet lifting into place —
/// use for onboarding-style full-screen steps rather than lateral
/// navigation (list → detail).
Route<T> riseInRoute<T>(Widget page, {RouteSettings? settings}) {
  return PageRouteBuilder<T>(
    settings: settings,
    transitionDuration: const Duration(milliseconds: 420),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curve,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(curve),
          child: child,
        ),
      );
    },
  );
}