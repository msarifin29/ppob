// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ppob/core/core.dart';

import 'package:ppob/features/auth/auth.dart';

class LoginProvider with ChangeNotifier {
  final AuthRepository repository;
  LoginProvider({required this.repository});

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  Future<void> unAuthorize() async {
    await repository.removeToken();
    _isSuccess = false;
    notifyListeners();
  }

  Future<void> call(LoginParam param) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await repository.login(param);
      if (response != null) {
        _isSuccess = await repository.saveToken(response.token);
      }
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      log('error login-> ${e.toString()}');
      _setError('Something wrong!');
    }
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
