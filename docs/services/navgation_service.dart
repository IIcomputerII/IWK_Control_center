import 'package:flutter/material.dart';

class NavigationService{
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop() {
    return _navigationKey.currentState?.pop();
  }

  void popWithValue(String value) {
    return _navigationKey.currentState?.pop('$value');
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> replaceTo(String routeName, {dynamic arguments}) async {
    return _navigationKey.currentState?.pushNamedAndRemoveUntil(routeName, (route) => false);
  }
}