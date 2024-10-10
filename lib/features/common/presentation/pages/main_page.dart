import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  static const routeName = 'main';
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Hello'),
          ],
        ),
      ),
    );
  }
}
