import 'package:flutter/material.dart';
import 'package:ppob/features/auth/auth.dart';
import 'package:ppob/features/common/common.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashPage.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return const SplashPage();
          },
        );
      case LoginPage.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return const LoginPage();
          },
        );
      case RegisterPage.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return const RegisterPage();
          },
        );
      case MainPage.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return const MainPage();
          },
        );

      default:
        return MaterialPageRoute(
          builder: (context) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: Text('Page Not Fount')),
            );
          },
        );
    }
  }
}
