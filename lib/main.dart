import 'dart:async';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ppob/features/auth/auth.dart';
import 'package:ppob/features/common/common.dart';
import 'package:ppob/features/transaction/transaction.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/core.dart';

FutureOr<void> main() async {
  final localeDataSource = AuthLocaleDataSourceImpl();
  final remoteDataSource = AuthRemoteDataosourceImpl();
  final authRepository = AuthRepositoryImpl(
    localeDataSource: localeDataSource,
    remoteDataosource: remoteDataSource,
  );

  final dio = Dio();
  dio.interceptors.add(DioLoggingInterceptor(dio));
  final profileRemoteDatasource = ProfileRemoteDatasourceImpl(dio: dio);
  final profileRepository = ProfileRepositoryImpl(remoteDatasource: profileRemoteDatasource);

  final commonRemoteDatasource = CommonRemoteDatasourceImpl(dio: dio);
  final commonRepository = CommonRepositoryImpl(remoteDatasource: commonRemoteDatasource);
  final transactionRemoteDatasource = TransactionRemoteDatasourceImpl(dio: dio);
  final transactionRepository = TransactionRepositoryImpl(
    remoteDatasource: transactionRemoteDatasource,
  );

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await initializeDateFormatting('id_ID', null);
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
        runApp(MultiProvider(providers: [
          ChangeNotifierProvider(create: (_) => LoginProvider(repository: authRepository)),
          ChangeNotifierProvider(create: (_) => RegisterProvider(repository: authRepository)),
          ChangeNotifierProvider(create: (_) => ProfileProvider(repository: profileRepository)),
          ChangeNotifierProvider(create: (_) => BannerProvider(repository: commonRepository)),
          ChangeNotifierProvider(create: (_) => ServiceProvider(repository: commonRepository)),
          ChangeNotifierProvider(
            create: (_) => TransactionProvider(repository: transactionRepository),
          ),
          ChangeNotifierProvider(
            create: (_) => TransactionHistoryProvider(repository: transactionRepository),
          ),
        ], child: const MyApp()));
      });
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
