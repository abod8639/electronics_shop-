import '../entities/support_entity.dart';
import '../repositories/support_repository.dart';

class CreateSupportUsecase {
  final SupportRepository repository;

  CreateSupportUsecase(this.repository);

  Future<void> call(SupportEntity entity) => repository.createSupport(entity);
}
