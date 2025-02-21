import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../app/shared_prefs/token_shared_prefs.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/auth_repository.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  // Initial Constructor
  const LoginParams.initial()
      : email = '',
        password = '';

  @override
  List<Object> get props => [email, password];
}

// class LoginUseCase implements UsecaseWithParams<String, LoginParams> {
//   final IAuthRepository repository;
//   final TokenSharedPrefs tokenSharedPrefs;

//   LoginUseCase(this.repository, this.tokenSharedPrefs);

//   @override
//   Future<Either<Failure, String>> call(LoginParams params) async {
//     final result = await repository.loginUser(params.email, params.password);

//     return result.fold(
//       (failure) => Left(failure), // Return failure if login fails
//       (token) async {
//         await tokenSharedPrefs.saveToken(token);
//         final savedToken = await tokenSharedPrefs.getToken();
//         print(savedToken);
//         return Right(token);
//       },
//     );
//   }
// }

class LoginUseCase implements UsecaseWithParams<String, LoginParams> {
  final IAuthRepository repository;
  final TokenSharedPrefs tokenSharedPrefs;

  LoginUseCase(this.repository, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    final result = await repository.loginUser(params.email, params.password);

    return result.fold(
      (failure) => Left(failure),
      (token) async {
        print("✅ Token Received: $token"); // Debug Log

        await tokenSharedPrefs.saveToken(token);
        final savedToken = await tokenSharedPrefs.getToken();

        print("🔑 Stored Token: $savedToken"); // Debugging log

        return Right(token);
      },
    );
  }
}
