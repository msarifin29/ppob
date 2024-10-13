// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ppob/features/transaction/transaction.dart';

abstract class TransactionRepository {
  Future<BalanceResponse> balance();
  Future<BalanceResponse> topup(TopUpParam param);
  Future<bool> payment(PaymentParam param);
}

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDatasource remoteDatasource;
  TransactionRepositoryImpl({required this.remoteDatasource});

  @override
  Future<BalanceResponse> balance() async {
    return await remoteDatasource.balance();
  }

  @override
  Future<BalanceResponse> topup(TopUpParam param) async {
    return await remoteDatasource.topup(param);
  }

  @override
  Future<bool> payment(PaymentParam param) async {
    return await remoteDatasource.payment(param);
  }
}
