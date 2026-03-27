import 'package:electronics_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:electronics_shop/features/profile/data/models/user_model.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<UserModel?> call() {
    return repository.getCurrentUser();
  }
}
