import 'package:flutter/material.dart';
import 'package:ppob/features/transaction/transaction.dart';

class TransactionHistoryProvider with ChangeNotifier {
  final TransactionRepository repository;
  TransactionHistoryProvider({required this.repository});

  static const _pageSize = 5;
  bool _isLoading = false;
  bool _isLastPage = false;
  int _currentPage = 0;

  final List<TransactionRecord> _records = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLastPage => _isLastPage;
  List<TransactionRecord> get records => _records;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTransactions({bool loadMore = false}) async {
    if (_isLoading) return;
    if (_isLastPage && loadMore) return;
    _setMessage(null);
    _setLoading(true);

    try {
      if (!loadMore) {
        _currentPage = 0;
        _records.clear();
      }

      final response = await repository.transaction(_currentPage, _pageSize);
      final List<TransactionRecord> newRecords = response.records;

      if (newRecords.length < _pageSize) {
        _isLastPage = true;
      }

      _records.addAll(newRecords);
      _currentPage++;
    } catch (e) {
      _setMessage('Failed to load data');
    }

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }
}
