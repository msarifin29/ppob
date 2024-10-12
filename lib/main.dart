import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ppob/features/auth/auth.dart';
import 'package:ppob/features/common/common.dart';
import 'package:provider/provider.dart';

import 'core/core.dart';

FutureOr<void> main() async {
  final dio = Dio();
  dio.interceptors.add(DioLoggingInterceptor(dio));

  final localeDataSource = AuthLocaleDataSourceImpl();
  final remoteDataSource = AuthRemoteDataosourceImpl();
  final authRepository = AuthRepositoryImpl(
    localeDataSource: localeDataSource,
    remoteDataosource: remoteDataSource,
  );
  final profileRemoteDatasource = ProfileRemoteDatasourceImpl(dio: dio);
  final profileRepository = ProfileRepositoryImpl(remoteDatasource: profileRemoteDatasource);
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider(repository: authRepository)),
        ChangeNotifierProvider(create: (_) => RegisterProvider(repository: authRepository)),
        ChangeNotifierProvider(create: (_) => ProfileProvider(repository: profileRepository)),
      ], child: const MyApp()));
    },
    (error, stackTrace) {
      log('Error: $error');
      log('Stack Trace: $stackTrace');
    },
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(useMaterial3: true),
      home: const SplashPage(),
      onGenerateRoute: (settings) => AppRoute.generateRoute(settings),
    );
  }
}
