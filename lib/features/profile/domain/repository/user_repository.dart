import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../auth/domain/entity/auth_entity.dart';

abstract interface class UserRepository {
  Future<Either<Failure, AuthEntity>> getUserProfile();
}
