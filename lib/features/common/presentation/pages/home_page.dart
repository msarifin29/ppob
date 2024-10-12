import 'package:flutter/material.dart';
import 'package:ppob/features/auth/auth.dart';
import 'package:ppob/features/common/common.dart';
import 'package:ppob/features/transaction/transaction.dart';

class HomePage extends StatelessWidget {
  static const routeName = 'home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [HomeProfile(), BalanceWidget(), ServicesWidget(), BannerWidget()],
        ),
      ),
    );
  }
}
