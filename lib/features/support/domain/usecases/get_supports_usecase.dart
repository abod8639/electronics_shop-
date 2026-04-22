import '../entities/support_entity.dart';
import '../repositories/support_repository.dart';

class GetSupportsUsecase {
  final SupportRepository repository;

  GetSupportsUsecase(this.repository);

  Future<List<SupportEntity>> call() => repository.getAllSupports();
}
