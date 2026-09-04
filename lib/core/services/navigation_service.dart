import 'package:flutter/material.dart';

class NavigationService {
  final navigationKey = GlobalKey<NavigatorState>();

  Future<T?>? pushNamed<T extends Object?>(
    String routeName, {
    Object? args,
  }) =>
      navigationKey.currentState?.pushNamed(routeName, arguments: args);

  Future<T?>? pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? args,
  }) =>
      navigationKey.currentState?.pushReplacementNamed(
        routeName,
        arguments: args,
        result: result,
      );

  Future<T?>? pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName, {
    required String removeUntilRouteName,
    Object? arguments,
  }) =>
      navigationKey.currentState?.pushNamedAndRemoveUntil(
        newRouteName,
        ModalRoute.withName(removeUntilRouteName),
        arguments: arguments,
      );

  void pop<T extends Object?>([T? result]) =>
      navigationKey.currentState?.pop(result);

  void popUntil(String routeName) =>
      navigationKey.currentState?.popUntil(ModalRoute.withName(routeName));
}
