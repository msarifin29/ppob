// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field, unnecessary_null_comparison
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:ppob/features/auth/auth.dart';
import 'package:ppob/main.dart';

class DioLoggingInterceptor extends InterceptorsWrapper {
  final Dio _dio;

  DioLoggingInterceptor(
    this._dio,
  );

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        // Don't trust any certificate just because their root cert is trusted.
        final HttpClient client = HttpClient(context: SecurityContext(withTrustedRoots: false));
        // You can test the intermediate / root cert here. We just ignore it.
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );
    debugPrint('--> ${options.method.toUpperCase()} ${options.baseUrl + options.path}');
    if (options.headers.containsKey(BaseUrlConfig.requiredToken)) {
      final localData = AuthLocaleDataSourceImpl();
      var accessToken = await localData.getToken();
      options.headers.remove(BaseUrlConfig.requiredToken);
      options.headers.addAll({HttpHeaders.authorizationHeader: 'Bearer $accessToken'});
    }
    if (options.extra.containsKey(BaseUrlConfig.toFormData)) {
      options.extra.remove(BaseUrlConfig.toFormData);
      options.data = FormData.fromMap(options.data);
    }
    options.headers.addAll({HttpHeaders.acceptHeader: 'application/json'});
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        '<-- ${response.statusCode} ${response.requestOptions.baseUrl + response.requestOptions.path}');

    handler.next(response);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    final localData = AuthLocaleDataSourceImpl();
    debugPrint(
        '<-- ${err.message} ${(err.response?.requestOptions != null ? ((err.response?.requestOptions.baseUrl ?? '') + (err.response?.requestOptions.path ?? '')) : 'URL')}');

    var responseCode = err.response?.statusCode;
    debugPrint("<-- response data = ${err.response?.data}");
    debugPrint("<-- response code = $responseCode");

    if (responseCode == 401) {
      await localData.removeToken();
      await navigatorKey.currentState?.pushNamed(LoginPage.routeName);
    }
    return handler.next(err);
  }
}

class BaseUrlConfig {
  // Header
  static const requiredToken = 'requiredToken';
  static const toFormData = "toFormData";
}
