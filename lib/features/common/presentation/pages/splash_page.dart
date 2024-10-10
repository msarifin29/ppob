import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ppob/core/core.dart';
import 'package:ppob/features/auth/auth.dart';

class SplashPage extends StatefulWidget {
  static const routeName = '/';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    loadingProccess();
    super.initState();
  }

  void loadingProccess() async {
    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName, ModalRoute.withName('/'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(ImageName.logo), fit: BoxFit.cover),
              ),
            ),
            const Gap(15),
            Text(
              'SIMS PPOB',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Gap(15),
            const Text('M Syamsul Arifin'),
          ],
        ),
      ),
    );
  }
}
