// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:ppob/core/core.dart';

import 'package:ppob/features/transaction/transaction.dart';

abstract class TransactionRemoteDatasource {
  Future<BalanceResponse?> balance();
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  final Dio dio;
  TransactionRemoteDatasourceImpl({required this.dio});

  @override
  Future<BalanceResponse?> balance() async {
    const path = '${ApiUrl.endPoint}/balance';
    try {
      final response = await dio.get(path,
          options: Options(
            headers: {BaseUrlConfig.requiredToken: true},
          ));
      return BalanceResponse.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final errorJsonData = e.response?.data as Map<String, dynamic>;
        final message = errorJsonData['message'] ?? 'Unknown error';
        final status = errorJsonData['status'] ?? e.response?.statusCode;
        throw ApiException(status, message);
      } else {
        DioExceptionImpl().handleDioError(e);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
