import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:ppob/core/core.dart';
import 'package:ppob/features/auth/auth.dart';

abstract class ProfileRemoteDatasource {
  Future<ProfileResponse?> fetch();
  Future<ProfileResponse?> update(UpdateProfileParam param);
  Future<ProfileResponse?> updatePhoto(File file);
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final Dio dio;
  ProfileRemoteDatasourceImpl({required this.dio});

  @override
  Future<ProfileResponse?> fetch() async {
    const path = '${ApiUrl.endPoint}/profile';
    try {
      final response = await dio.get(
        path,
        options: Options(headers: {BaseUrlConfig.requiredToken: true}),
      );
      return ProfileResponse.fromJson(response.data['data']);
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
  Future<ProfileResponse?> update(UpdateProfileParam param) async {
    const path = '${ApiUrl.endPoint}/profile/update';

    try {
      final response = await dio.put(
        path,
        options: Options(headers: {BaseUrlConfig.requiredToken: true}),
        data: param.toMap(),
      );
      return ProfileResponse.fromJson(response.data['data']);
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
  Future<ProfileResponse?> updatePhoto(File file) async {
    const path = '${ApiUrl.endPoint}/profile/image';

    List<String>? mimeTypeData = lookupMimeType(file.path, headerBytes: [0xFF, 0xD8])!.split('/');
    Map<String, dynamic> data = {
      'file': await MultipartFile.fromFile(
        file.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ),
    };

    try {
      final response = await dio.put(
        path,
        options: Options(
          headers: {BaseUrlConfig.requiredToken: true},
          extra: {
            BaseUrlConfig.toFormData: true,
          },
        ),
        data: data,
      );
      return ProfileResponse.fromJson(response.data['data']);
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

class UpdateProfileParam extends Equatable {
  final String? firstName;
  final String? lastName;
  const UpdateProfileParam({
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    return data;
  }

  @override
  List<Object?> get props => [firstName, lastName];
}
