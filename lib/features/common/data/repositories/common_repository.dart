// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ppob/features/common/common.dart';

abstract class CommonRepository {
  Future<List<BannerResponse>?> banner();
  Future<List<ServiceResponse>?> services();
}

class CommonRepositoryImpl implements CommonRepository {
  final CommonRemoteDatasource remoteDatasource;
  CommonRepositoryImpl({required this.remoteDatasource});
  @override
  Future<List<BannerResponse>?> banner() async {
    return await remoteDatasource.banner();
  }

  @override
  Future<List<ServiceResponse>?> services() async {
    return await remoteDatasource.services();
  }
}
