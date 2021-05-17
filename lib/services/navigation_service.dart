import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

class NavigationServices {
  GlobalKey<NavigatorState> navigatorKey;

  static NavigationServices instance = NavigationServices();

  NavigationServices() {
    navigatorKey = GlobalKey<NavigatorState>();
  }
  Future<dynamic> navigateToReplacement(String _routeName) {
    return navigatorKey.currentState.pushReplacementNamed(_routeName);
  }

  Future<dynamic> navigateTo(String _routeName) {
    return navigatorKey.currentState.pushNamed(_routeName);
  }

  Future<dynamic> navigateToRoute(MaterialPageRoute _routeName) {
    return navigatorKey.currentState.push(_routeName);
  }

  void goBack() {
    return navigatorKey.currentState.pop();
  }
}
