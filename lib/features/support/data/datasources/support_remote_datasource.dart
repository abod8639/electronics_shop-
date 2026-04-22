import '../models/support_model.dart';

abstract class SupportRemoteDatasource {
  Future<List<SupportModel>> getAllSupports();
  Future<SupportModel> getSupportById(String id);
  Future<void> createSupport(SupportModel model);
}

class SupportRemoteDatasourceImpl implements SupportRemoteDatasource {
  // TODO: inject Dio / http client

  @override
  Future<List<SupportModel>> getAllSupports() async {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<SupportModel> getSupportById(String id) async {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> createSupport(SupportModel model) async {
    // TODO: implement API call
    throw UnimplementedError();
  }
}
