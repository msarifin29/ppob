// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ppob/features/transaction/transaction.dart';

abstract class TransactionRepository {
  Future<BalanceResponse?> balance();
}

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDatasource remoteDatasource;
  TransactionRepositoryImpl({required this.remoteDatasource});

  @override
  Future<BalanceResponse?> balance() async {
    return await remoteDatasource.balance();
  }
}
