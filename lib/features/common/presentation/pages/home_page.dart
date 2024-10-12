import 'package:flutter/material.dart';
import 'package:ppob/features/auth/auth.dart';

class HomePage extends StatelessWidget {
  static const routeName = 'home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          HomeProfile(),
        ],
      ),
    );
  }
}
