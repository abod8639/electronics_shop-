import '../entities/support_entity.dart';

abstract class SupportRepository {
  Future<List<SupportEntity>> getAllSupports();
  Future<SupportEntity> getSupportById(String id);
  Future<void> createSupport(SupportEntity entity);
}
