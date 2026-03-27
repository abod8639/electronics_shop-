import 'package:electronics_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:electronics_shop/features/profile/data/models/user_model.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<UserModel> call({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) {
    return repository.updateProfile(
      name: name,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
    );
  }
}
