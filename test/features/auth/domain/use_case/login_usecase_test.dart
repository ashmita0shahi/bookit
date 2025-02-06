import 'package:bookit/core/error/failure.dart';
import 'package:bookit/features/auth/domain/use_case/login_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'repository.mock.dart';
import 'token.mock.dart';

void main() {
  late MockAuthRepository repository;
  late MockTokenSharedPrefs tokenSharedPrefs;
  late LoginUseCase loginUseCase;

  setUp(() {
    repository = MockAuthRepository();
    tokenSharedPrefs = MockTokenSharedPrefs();
    loginUseCase = LoginUseCase(repository, tokenSharedPrefs);
  });

  const userLoginParams = LoginParams(
    email: "test@example.com",
    password: "123456",
  );

  const generatedToken = "mock_jwt_token";

  group('LoginUseCase Tests', () {
    test('Returns Failure when credentials are incorrect', () async {
      // Arrange
      when(() => repository.loginUser(any(), any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: "Invalid credentials")));

      // Act
      final result = await loginUseCase(userLoginParams);

      // Assert
      expect(result, const Left(ApiFailure(message: "Invalid credentials")));
      verify(() => repository.loginUser(
          userLoginParams.email, userLoginParams.password)).called(1);
      verifyNever(() => tokenSharedPrefs.saveToken(any()));
    });

    test('Returns Failure when email is empty', () async {
      // Arrange
      const invalidParams = LoginParams(email: "", password: "123456");
      when(() => repository.loginUser(any(), any())).thenAnswer((_) async =>
          const Left(ApiFailure(message: "Email cannot be empty")));

      // Act
      final result = await loginUseCase(invalidParams);

      // Assert
      expect(result, const Left(ApiFailure(message: "Email cannot be empty")));
      verify(() => repository.loginUser(any(), any())).called(1);
      verifyNever(() => tokenSharedPrefs.saveToken(any()));
    });

    test('Returns Failure when password is empty', () async {
      // Arrange
      const invalidParams =
          LoginParams(email: "test@example.com", password: "");
      when(() => repository.loginUser(any(), any())).thenAnswer((_) async =>
          const Left(ApiFailure(message: "Password cannot be empty")));

      // Act
      final result = await loginUseCase(invalidParams);

      // Assert
      expect(
          result, const Left(ApiFailure(message: "Password cannot be empty")));
      verify(() => repository.loginUser(any(), any())).called(1);
      verifyNever(() => tokenSharedPrefs.saveToken(any()));
    });

    test('Returns Failure when there is a server error', () async {
      // Arrange
      when(() => repository.loginUser(any(), any())).thenAnswer((_) async =>
          const Left(ApiFailure(message: "Internal Server Error")));

      // Act
      final result = await loginUseCase(userLoginParams);

      // Assert
      expect(result, const Left(ApiFailure(message: "Internal Server Error")));
      verify(() => repository.loginUser(
          userLoginParams.email, userLoginParams.password)).called(1);
      verifyNever(() => tokenSharedPrefs.saveToken(any()));
    });

    test('Returns successfully and saves token', () async {
      // Arrange
      when(() => repository.loginUser(any(), any()))
          .thenAnswer((_) async => const Right(generatedToken));
      when(() => tokenSharedPrefs.saveToken(any()))
          .thenAnswer((_) async => const Right(null));
      when(() => tokenSharedPrefs.getToken())
          .thenAnswer((_) async => const Right(generatedToken));

      // Act
      final result = await loginUseCase(userLoginParams);

      // Assert
      expect(result, const Right(generatedToken));
      verify(() => repository.loginUser(
          userLoginParams.email, userLoginParams.password)).called(1);
      verify(() => tokenSharedPrefs.saveToken(generatedToken)).called(1);
      verify(() => tokenSharedPrefs.getToken()).called(1);
    });
  });
}
