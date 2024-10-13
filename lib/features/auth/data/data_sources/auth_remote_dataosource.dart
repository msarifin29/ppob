import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:ppob/core/core.dart';
import 'package:ppob/features/auth/auth.dart';

abstract class AuthRemoteDataosource {
  Future<LoginResponse> login(LoginParam param);
  Future<bool> register(RegisterParam param);
}

class AuthRemoteDataosourceImpl implements AuthRemoteDataosource {
  @override
  Future<LoginResponse> login(LoginParam param) async {
    const path = '${ApiUrl.endPoint}/login';
    try {
      final response = await Dio().post(
        path,
        options: Options(
          headers: {HttpHeaders.acceptHeader: 'application/json'},
        ),
        data: param.toMap(),
      );
      return LoginResponse.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final errorJsonData = e.response?.data as Map<String, dynamic>;
        final message = errorJsonData['message'] ?? 'Unknown error';
        final status = errorJsonData['status'] ?? e.response?.statusCode;
        throw ApiException(status, message);
      } else {
        DioExceptionImpl().handleDioError(e);
        throw Exception(e.message ?? '');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> register(RegisterParam param) async {
    const path = '${ApiUrl.endPoint}/registration';
    try {
      await Dio().post(
        path,
        options: Options(
          headers: {HttpHeaders.acceptHeader: 'application/json'},
        ),
        data: param.toMap(),
      );
      return true;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final errorJsonData = e.response?.data as Map<String, dynamic>;
        final message = errorJsonData['message'] ?? 'Unknown error';
        final status = errorJsonData['status'] ?? e.response?.statusCode;
        throw ApiException(status, message);
      } else {
        DioExceptionImpl().handleDioError(e);
        throw Exception(e.message ?? '');
      }
    } catch (e) {
      rethrow;
    }
  }
}

class LoginParam extends Equatable {
  final String email;
  final String password;
  const LoginParam({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['email'] = email;
    data['password'] = password;
    return data;
  }

  @override
  List<Object?> get props => [email, password];
}

class RegisterParam extends Equatable {
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  const RegisterParam({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['password'] = password;
    return data;
  }

  @override
  List<Object?> get props => [email, firstName, lastName, password];
}
