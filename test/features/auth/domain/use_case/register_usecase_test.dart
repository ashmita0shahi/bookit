import 'package:bookit/core/error/failure.dart';
import 'package:bookit/features/auth/domain/entity/auth_entity.dart';
import 'package:bookit/features/auth/domain/use_case/register_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'repository.mock.dart';

void main() {
  late MockAuthRepository repository;
  late RegisterUseCase registerUseCase;

  setUpAll(() {
    registerFallbackValue(const AuthEntity.empty()); // ✅ Register fallback once
  });

  setUp(() {
    repository = MockAuthRepository();
    registerUseCase = RegisterUseCase(repository);
  });

  const registerUserParams = RegisterUserParams(
    fullname: "Ashmita Shahi",
    phoneNo: "9876543210",
    address: "Dhading",
    email: "asmita@gmmail.com",
    password: "password3333",
    image: "profile_image.png",
  );

  group('RegisterUseCase Tests', () {
    test('Returns Failure when email is already in use', () async {
      // Arrange
      when(() => repository.registerUser(any())).thenAnswer((_) async =>
          const Left(ApiFailure(message: "Email already registered")));

      // Act
      final result = await registerUseCase(registerUserParams);

      // Assert
      expect(
          result, const Left(ApiFailure(message: "Email already registered")));
      verify(() => repository.registerUser(any()))
          .called(1); // ✅ Fix: Use any()
    });

    test('Returns Failure when email is invalid', () async {
      // Arrange
      const invalidParams = RegisterUserParams(
        fullname: "Ashmita Shahi",
        phoneNo: "9876543210",
        address: "Dhading",
        email: "invalidemail",
        password: "password3333",
        image: "profile_image.png",
      );
      when(() => repository.registerUser(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: "Invalid email format")));

      // Act
      final result = await registerUseCase(invalidParams);

      // Assert
      expect(result, const Left(ApiFailure(message: "Invalid email format")));
      verify(() => repository.registerUser(any()))
          .called(1); // ✅ Fix: Use any()
    });

    test('Returns Failure when password is too weak', () async {
      // Arrange
      const invalidParams = RegisterUserParams(
        fullname: "Ashmita Shahi",
        phoneNo: "9876543210",
        address: "Dhading",
        email: "asmita@gmmail.com",
        password: "123",
        image: "profile_image.png",
      );
      when(() => repository.registerUser(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: "Password too weak")));

      // Act
      final result = await registerUseCase(invalidParams);

      // Assert
      expect(result, const Left(ApiFailure(message: "Password too weak")));
      verify(() => repository.registerUser(any()))
          .called(1); // ✅ Fix: Use any()
    });

    test('Returns Failure when phone number is invalid', () async {
      // Arrange
      const invalidParams = RegisterUserParams(
        fullname: "Ashmita Shahi",
        phoneNo: "123",
        address: "Dhading",
        email: "asmita@gmmail.com",
        password: "password3333",
        image: "profile_image.png",
      );
      when(() => repository.registerUser(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: "Invalid phone number")));

      // Act
      final result = await registerUseCase(invalidParams);

      // Assert
      expect(result, const Left(ApiFailure(message: "Invalid phone number")));
      verify(() => repository.registerUser(any()))
          .called(1); // ✅ Fix: Use any()
    });

    test('Returns Failure when there is a server error', () async {
      // Arrange
      when(() => repository.registerUser(any())).thenAnswer((_) async =>
          const Left(ApiFailure(message: "Internal Server Error")));

      // Act
      final result = await registerUseCase(registerUserParams);

      // Assert
      expect(result, const Left(ApiFailure(message: "Internal Server Error")));
      verify(() => repository.registerUser(any()))
          .called(1); // ✅ Fix: Use any()
    });

    test('Successfully registers the user', () async {
      // Arrange
      when(() => repository.registerUser(any()))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await registerUseCase(registerUserParams);

      // Assert
      expect(result, const Right(null));
      verify(() => repository.registerUser(any()))
          .called(1); // ✅ Fix: Use any()
    });
  });
}
