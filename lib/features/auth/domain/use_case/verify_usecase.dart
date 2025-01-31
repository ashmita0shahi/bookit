import 'package:dartz/dartz.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/auth_repository.dart';

class VerifyEmailParams {
  final String email;
  final String otp;

  VerifyEmailParams({required this.email, required this.otp});
}

class VerifyEmailUsecase implements UsecaseWithParams<void, VerifyEmailParams> {
  final IAuthRepository repository;

  VerifyEmailUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(VerifyEmailParams params) {
    return repository.verifyEmail(params.email, params.otp);
  }
}
