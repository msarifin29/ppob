import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ppob/features/auth/auth.dart';
import 'package:ppob/features/common/common.dart';
import 'package:provider/provider.dart';

import 'core/core.dart';

FutureOr<void> main() async {
  final localeDataSource = AuthLocaleDataSourceImpl();
  final remoteDataSource = AuthRemoteDataosourceImpl();
  final authRepository = AuthRepositoryImpl(
    localeDataSource: localeDataSource,
    remoteDataosource: remoteDataSource,
  );
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider(repository: authRepository)),
        ChangeNotifierProvider(create: (_) => RegisterProvider(repository: authRepository)),
      ], child: const MyApp()));
    },
    (error, stackTrace) {
      log('Error: $error');
      log('Stack Trace: $stackTrace');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const SplashPage(),
      onGenerateRoute: (settings) => AppRoute.generateRoute(settings),
    );
  }
}
