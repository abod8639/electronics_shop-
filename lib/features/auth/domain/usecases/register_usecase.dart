import 'package:electronics_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:electronics_shop/features/profile/data/models/user_model.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserModel> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.register(name: name, email: email, password: password);
  }
}
