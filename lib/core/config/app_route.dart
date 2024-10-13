import 'package:flutter/material.dart';
import 'package:ppob/features/auth/auth.dart';
import 'package:ppob/features/common/common.dart';
import 'package:ppob/features/transaction/transaction.dart';

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

      case HomePage.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return const HomePage();
          },
        );

      case AccountPage.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return const AccountPage();
          },
        );

      case EditProfilePage.routeName:
        final arguments = settings.arguments as Map<String, dynamic>;
        final email = arguments['email'] as String;
        final image = arguments['image'] as String;
        final firstName = arguments['firstName'] as String;
        final lastName = arguments['lastName'] as String;
        return MaterialPageRoute(
          builder: (context) {
            return EditProfilePage(
              email: email,
              image: image,
              firstName: firstName,
              lastName: lastName,
            );
          },
        );

      case TopUpPage.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return const TopUpPage();
          },
        );

      case PaymentPage.routeName:
        final arguments = settings.arguments as Map<String, dynamic>;
        final serviceIcon = arguments['serviceIcon'] as String;
        final serviceName = arguments['serviceName'] as String;
        final serviceCode = arguments['serviceCode'] as String;
        final amount = arguments['amount'] as String;
        return MaterialPageRoute(
          builder: (context) {
            return PaymentPage(
              serviceIcon: serviceIcon,
              serviceName: serviceName,
              serviceCode: serviceCode,
              amount: amount,
            );
          },
        );

      case TransactionPage.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return const TransactionPage();
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
