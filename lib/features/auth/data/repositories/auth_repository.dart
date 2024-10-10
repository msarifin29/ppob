// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ppob/features/auth/auth.dart';

abstract class AuthRepository {
  Future<bool> saveToken(String token);
  Future<String?> getToken();
  Future<bool> removeToken();
  Future<LoginResponse?> login(LoginParam param);
  Future<bool> register(RegisterParam param);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocaleDataSource localeDataSource;
  final AuthRemoteDataosource remoteDataosource;
  AuthRepositoryImpl({
    required this.localeDataSource,
    required this.remoteDataosource,
  });

  @override
  Future<String?> getToken() async {
    return await localeDataSource.getToken();
  }

  @override
  Future<LoginResponse?> login(LoginParam param) async {
    return await remoteDataosource.login(param);
  }

  @override
  Future<bool> removeToken() async {
    return await localeDataSource.removeToken();
  }

  @override
  Future<bool> saveToken(String token) async {
    return await localeDataSource.saveToken(token);
  }

  @override
  Future<bool> register(RegisterParam param) async {
    return await remoteDataosource.register(param);
  }
}
