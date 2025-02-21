import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../auth/domain/entity/auth_entity.dart';

import '../repository/user_repository.dart';

class GetUserProfileUseCase {
  final UserRepository userRepository;

  GetUserProfileUseCase(this.userRepository);

  Future<Either<Failure, AuthEntity>> call() {
    return userRepository.getUserProfile(); // No need to pass userId explicitly
  }
}
