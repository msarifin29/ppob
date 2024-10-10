import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

class ApiException implements Exception, Equatable {
  final int? status;
  final String message;

  ApiException(this.status, this.message);

  @override
  String toString() => 'ApiException(status: $status, message: $message)';

  @override
  List<Object?> get props => [status, message];

  @override
  bool? get stringify => false;
}

class DioExceptionImpl {
  void handleDioError(DioException e) {
    debugPrint('DioExeption ${e.type}');
    if (e.type == DioExceptionType.connectionTimeout) {
      throw ApiException(408, 'Connection Timeout');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      throw ApiException(408, 'Receive Timeout');
    } else if (e.type == DioExceptionType.badResponse) {
      throw ApiException(e.response?.statusCode, 'Server Error');
    } else if (e.type == DioExceptionType.cancel) {
      throw ApiException(null, 'Request Cancelled');
    } else if (e.type == DioExceptionType.unknown) {
      throw ApiException(null, 'No Internet Connection');
    } else if (e.type == DioExceptionType.connectionError) {
      throw ApiException(null, 'Connection Error');
    } else {
      throw ApiException(null, 'Unexpected Error: ${e.message}');
    }
  }
}
