import '../models/support_model.dart';

abstract class SupportLocalDatasource {
  Future<List<SupportModel>> getCachedSupports();
  Future<void> cacheSupports(List<SupportModel> models);
}

class SupportLocalDatasourceImpl implements SupportLocalDatasource {
  // TODO: inject SharedPreferences / Hive / Isar

  @override
  Future<List<SupportModel>> getCachedSupports() async {
    // TODO: implement local read
    throw UnimplementedError();
  }

  @override
  Future<void> cacheSupports(List<SupportModel> models) async {
    // TODO: implement local write
    throw UnimplementedError();
  }
}
