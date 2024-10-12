// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ppob/core/core.dart';

import 'package:ppob/features/auth/auth.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepository repository;
  ProfileProvider({required this.repository});
  ProfileResponse? _profile;
  bool _isLoading = false;
  bool _isUpdate = false;
  String? _errorMessage;

  ProfileResponse? get user => _profile;
  bool get isLoading => _isLoading;
  bool get isUpdate => _isUpdate;
  String? get errorMessage => _errorMessage;

  Future<void> fetch() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await repository.fetch();
      _profile = response;
      _setStatus(false);
    } on ApiException catch (e) {
      _setMessage(e.message);
    } catch (e) {
      log(' fetch -> ${e.toString()}');
      _setMessage('Something wrong');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> update(UpdateProfileParam param) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await repository.update(param);
      _profile = response;
      _setStatus(true);
    } on ApiException catch (e) {
      _setMessage(e.message);
    } catch (e) {
      log('exception update -> ${e.toString()}');
      _setMessage('Something wrong');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updatePhoto(File file) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await repository.updatePhoto(file);
      _profile = response;
      _setStatus(true);
    } on ApiException catch (e) {
      _setMessage(e.message);
    } catch (e) {
      log('exception update -> ${e.toString()}');
      _setMessage('Something wrong');
    }
    _isLoading = false;
    notifyListeners();
  }

  void _setMessage(String? msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  void _setStatus(bool status) {
    _isUpdate = status;
    notifyListeners();
  }
}
