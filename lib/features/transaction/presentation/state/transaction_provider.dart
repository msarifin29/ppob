// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ppob/core/core.dart';

import 'package:ppob/features/transaction/transaction.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionRepository repository;
  TransactionProvider({required this.repository});

  BalanceResponse? _result;
  bool _isLoading = false;
  final bool _isLoadingUpdate = false;
  bool _isUpdate = false;
  bool _isUpdatePayment = false;
  String? _errorMessage;

  BalanceResponse? get result => _result;
  bool get isLoading => _isLoading;
  bool get isLoadingUpdate => _isLoadingUpdate;
  bool get isUpdate => _isUpdate;
  bool get isUpdatePayment => _isUpdatePayment;
  String? get errorMessage => _errorMessage;

  Future<void> balance() async {
    _setStatus(true);
    try {
      final response = await repository.balance();
      _result = response;
    } on ApiException catch (e) {
      _setMessage(e.message);
    } catch (e) {
      log('exception balance -> ${e.toString()}');
      _setMessage('Something wrong');
    } finally {
      _setStatus(false);
    }
  }

  Future<void> topup(String amount) async {
    _setStatus(true);
    _setUpdate(false);
    _setMessage(null);
    try {
      final response = await repository.topup(TopUpParam(topUpAmount: amount));
      _result = response;
    } on ApiException catch (e) {
      _setMessage(e.message);
    } catch (e) {
      log('exception topup -> ${e.toString()}');
      _setMessage('Something wrong');
    } finally {
      _setUpdate(true);
      _setStatus(false);
    }
  }

  Future<void> payment(String serviceCode) async {
    _setStatus(true);
    _setUpdatePayment(false);
    _setMessage(null);
    try {
      await repository.payment(PaymentParam(serviceCode: serviceCode));
    } on ApiException catch (e) {
      _setMessage(e.message);
    } catch (e) {
      log('exception payment -> ${e.toString()}');
      _setMessage('Something wrong');
    } finally {
      _setUpdatePayment(true);
      _setStatus(false);
    }
  }

  void resetUpdate() {
    _isUpdate = false;
    notifyListeners();
  }

  void _setMessage(String? msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  void _setStatus(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  void _setUpdate(bool status) {
    _isUpdate = status;
    notifyListeners();
  }

  void _setUpdatePayment(bool status) {
    _isUpdatePayment = status;
    notifyListeners();
  }

  void resetUpdatePayment() {
    _isUpdatePayment = false;
    notifyListeners();
  }
}
