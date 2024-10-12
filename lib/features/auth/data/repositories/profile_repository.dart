import 'dart:io';

import 'package:ppob/features/auth/auth.dart';

abstract class ProfileRepository {
  Future<ProfileResponse?> fetch();
  Future<ProfileResponse?> update(UpdateProfileParam param);
  Future<ProfileResponse?> updatePhoto(File file);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;
  ProfileRepositoryImpl({required this.remoteDatasource});

  @override
  Future<ProfileResponse?> fetch() async {
    return await remoteDatasource.fetch();
  }

  @override
  Future<ProfileResponse?> update(UpdateProfileParam param) async {
    return await remoteDatasource.update(param);
  }

  @override
  Future<ProfileResponse?> updatePhoto(File file) async {
    return await remoteDatasource.updatePhoto(file);
  }
}
