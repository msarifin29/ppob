import 'package:dio/dio.dart';

import 'package:ppob/core/core.dart';
import 'package:ppob/features/common/common.dart';

abstract class CommonRemoteDatasource {
  Future<List<BannerResponse>?> banner();
  Future<List<ServiceResponse>?> services();
}

class CommonRemoteDatasourceImpl implements CommonRemoteDatasource {
  final Dio dio;
  CommonRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<BannerResponse>?> banner() async {
    const path = '${ApiUrl.endPoint}/banner';
    try {
      final response = await dio.get(path,
          options: Options(
            headers: {BaseUrlConfig.requiredToken: true},
          ));
      List<dynamic> responses = response.data['data'];
      final banners = responses.map((e) => BannerResponse.fromJson(e)).toList();
      return banners;
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

  @override
  Future<List<ServiceResponse>?> services() async {
    const path = '${ApiUrl.endPoint}/services';
    try {
      final response = await dio.get(path,
          options: Options(
            headers: {BaseUrlConfig.requiredToken: true},
          ));
      List<dynamic> responses = response.data['data'];
      final services = responses.map((e) => ServiceResponse.fromJson(e)).toList();
      return services;
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
