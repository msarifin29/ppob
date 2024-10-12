// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ppob/core/core.dart';

import 'package:ppob/features/common/common.dart';

class ServiceProvider with ChangeNotifier {
  final CommonRepository repository;
  ServiceProvider({required this.repository});
  List<ServiceResponse>? _services;
  bool _isLoading = false;
  String? _errorMessage;

  List<ServiceResponse>? get result => _services;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetch() async {
    _setStatus(true);
    try {
      final response = await repository.services();
      _services = response;
    } on ApiException catch (e) {
      _setMessage(e.message);
    } catch (e) {
      log(' fetch -> ${e.toString()}');
      _setMessage('Something wrong');
    }
    _setStatus(false);
  }

  void _setMessage(String? msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  void _setStatus(bool status) {
    _isLoading = status;
    notifyListeners();
  }
}
