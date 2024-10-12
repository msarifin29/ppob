// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ppob/core/core.dart';

import 'package:ppob/features/transaction/transaction.dart';

class BalanceProvider with ChangeNotifier {
  final TransactionRepository repository;
  BalanceProvider({required this.repository});

  BalanceResponse? _result;
  bool _isLoading = false;
  String? _errorMessage;

  BalanceResponse? get result => _result;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetch() async {
    _setStatus(true);
    try {
      final response = await repository.balance();
      _result = response;
    } on ApiException catch (e) {
      _setMessage(e.message);
    } catch (e) {
      log('exception balance -> ${e.toString()}');
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
