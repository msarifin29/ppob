// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:ppob/core/core.dart';
import 'package:ppob/features/transaction/transaction.dart';

abstract class TransactionRemoteDatasource {
  Future<BalanceResponse> balance();
  Future<BalanceResponse> topup(TopUpParam param);
  Future<bool> payment(PaymentParam param);
  Future<TransactionResponse> transaction(int offset, int limit);
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  final Dio dio;
  TransactionRemoteDatasourceImpl({required this.dio});

  @override
  Future<BalanceResponse> balance() async {
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
        throw Exception(e.message ?? '');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BalanceResponse> topup(TopUpParam param) async {
    const path = '${ApiUrl.endPoint}/topup';
    try {
      final response = await dio.post(
        path,
        options: Options(
          headers: {BaseUrlConfig.requiredToken: true},
        ),
        data: param.toMap(),
      );
      return BalanceResponse.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final errorJsonData = e.response?.data as Map<String, dynamic>;
        final message = errorJsonData['message'] ?? 'Unknown error';
        final status = errorJsonData['status'] ?? e.response?.statusCode;
        throw ApiException(status, message);
      } else {
        DioExceptionImpl().handleDioError(e);
        throw Exception(e.message ?? '');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> payment(PaymentParam param) async {
    const path = '${ApiUrl.endPoint}/transaction';
    try {
      await dio.post(
        path,
        options: Options(
          headers: {BaseUrlConfig.requiredToken: true},
        ),
        data: param.toMap(),
      );
      return true;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final errorJsonData = e.response?.data as Map<String, dynamic>;
        final message = errorJsonData['message'] ?? 'Unknown error';
        final status = errorJsonData['status'] ?? e.response?.statusCode;
        throw ApiException(status, message);
      } else {
        DioExceptionImpl().handleDioError(e);
        throw Exception(e.message ?? '');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TransactionResponse> transaction(int offset, int limit) async {
    const path = '${ApiUrl.endPoint}/transaction/history';
    try {
      final response = await dio.get(
        path,
        options: Options(
          headers: {BaseUrlConfig.requiredToken: true},
        ),
        queryParameters: {'offset': offset, 'limit': limit},
      );
      final data = TransactionResponse.fromJson(response.data['data']);
      return TransactionResponse(
        records: data.records,
        offset: data.offset,
        limit: data.limit,
      );
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        final errorJsonData = e.response?.data as Map<String, dynamic>;
        final message = errorJsonData['message'] ?? 'Unknown error';
        final status = errorJsonData['status'] ?? e.response?.statusCode;
        throw ApiException(status, message);
      } else {
        DioExceptionImpl().handleDioError(e);
        throw Exception(e.message ?? '');
      }
    } catch (e) {
      rethrow;
    }
  }
}

class TopUpParam extends Equatable {
  final String topUpAmount;
  const TopUpParam({
    required this.topUpAmount,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['top_up_amount'] = double.parse(topUpAmount.replaceAll(RegExp(r'[^0-9]'), ''));
    return data;
  }

  @override
  List<Object?> get props => [topUpAmount];
}

class PaymentParam extends Equatable {
  final String serviceCode;
  const PaymentParam({
    required this.serviceCode,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['service_code'] = serviceCode;
    return data;
  }

  @override
  List<Object?> get props => [serviceCode];
}
