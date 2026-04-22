import '../entities/support_entity.dart';
import '../repositories/support_repository.dart';

class GetSupportByIdUsecase {
  final SupportRepository repository;

  GetSupportByIdUsecase(this.repository);

  Future<SupportEntity> call(String id) => repository.getSupportById(id);
}
