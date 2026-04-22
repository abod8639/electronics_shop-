import '../../domain/entities/support_entity.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_remote_datasource.dart';
import '../datasources/support_local_datasource.dart';
import '../models/support_model.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDatasource remoteDatasource;
  final SupportLocalDatasource localDatasource;

  SupportRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<SupportEntity>> getAllSupports() async {
    final models = await remoteDatasource.getAllSupports();
    await localDatasource.cacheSupports(models);
    return models;
  }

  @override
  Future<SupportEntity> getSupportById(String id) =>
      remoteDatasource.getSupportById(id);

  @override
  Future<void> createSupport(SupportEntity entity) =>
      remoteDatasource.createSupport(SupportModel(id: entity.id, name: entity.name));
}
