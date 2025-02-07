import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:bookit/core/error/failure.dart';
import 'package:bookit/features/auth/domain/use_case/register_usecase.dart';
import 'package:bookit/features/auth/domain/use_case/verify_usecase.dart';
import 'package:bookit/features/auth/presentation/view_model/register/register_bloc.dart';
import 'package:bookit/features/auth/presentation/view_model/register/register_event.dart';
import 'package:bookit/features/auth/presentation/view_model/register/register_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockVerifyEmailUsecase extends Mock implements VerifyEmailUsecase {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late RegisterBloc registerBloc;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockVerifyEmailUsecase mockVerifyEmailUsecase;

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    mockVerifyEmailUsecase = MockVerifyEmailUsecase();
    registerBloc = RegisterBloc(
      registerUseCase: mockRegisterUseCase,
      verifyEmailUsecase: mockVerifyEmailUsecase,
    );
  });

  tearDown(() {
    registerBloc.close();
  });

  group('RegisterBloc Tests', () {
    test('Initial state should be RegisterState.initial()', () {
      expect(registerBloc.state, RegisterState.initial());
    });

    blocTest<RegisterBloc, RegisterState>(
      'emits [isLoading: true, isSuccess: true] when RegisterUserEvent is successful',
      build: () {
        when(() => mockRegisterUseCase.call(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return registerBloc;
      },
      act: (bloc) => bloc.add(
        RegisterUserEvent(
          context: MockBuildContext(),
          fullname: "John Doe",
          phoneNo: "1234567890",
          address: "123 Main St",
          email: "john.doe@example.com",
          password: "password123",
          confirmPassword: "password123",
          file: File('path/to/file'),
        ),
      ),
      expect: () => [
        RegisterState.initial().copyWith(isLoading: true),
        RegisterState.initial().copyWith(isLoading: false, isSuccess: true),
      ],
      verify: (_) {
        verify(() => mockRegisterUseCase.call(any())).called(1);
      },
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [isLoading: false, isSuccess: false, errorMessage: "Email already registered"] when RegisterUserEvent fails due to duplicate email',
      build: () {
        when(() => mockRegisterUseCase.call(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: "Email already registered")),
        );
        return registerBloc;
      },
      act: (bloc) => bloc.add(
        RegisterUserEvent(
          context: MockBuildContext(),
          fullname: "John Doe",
          phoneNo: "1234567890",
          address: "123 Main St",
          email: "john.doe@example.com",
          password: "password123",
          confirmPassword: "password123",
          file: File('path/to/file'),
        ),
      ),
      expect: () => [
        RegisterState.initial().copyWith(isLoading: true),
        RegisterState.initial().copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: "Email already registered",
        ),
      ],
      verify: (_) {
        verify(() => mockRegisterUseCase.call(any())).called(1);
      },
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [isLoading: true, isOtpVerified: true] when VerifyOtpEvent is successful',
      build: () {
        when(() => mockVerifyEmailUsecase.call(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return registerBloc;
      },
      act: (bloc) => bloc.add(
        VerifyOtpEvent(
          context: MockBuildContext(),
          email: "john.doe@example.com",
          otp: "123456",
        ),
      ),
      expect: () => [
        RegisterState.initial().copyWith(isLoading: true),
        RegisterState.initial().copyWith(isLoading: false, isOtpVerified: true),
      ],
      verify: (_) {
        verify(() => mockVerifyEmailUsecase.call(any())).called(1);
      },
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [isLoading: false, isOtpVerified: false, errorMessage: "Invalid OTP"] when VerifyOtpEvent fails',
      build: () {
        when(() => mockVerifyEmailUsecase.call(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: "Invalid OTP")),
        );
        return registerBloc;
      },
      act: (bloc) => bloc.add(
        VerifyOtpEvent(
          context: MockBuildContext(),
          email: "john.doe@example.com",
          otp: "654321",
        ),
      ),
      expect: () => [
        RegisterState.initial().copyWith(isLoading: true),
        RegisterState.initial().copyWith(
          isLoading: false,
          isOtpVerified: false,
          errorMessage: "Invalid OTP",
        ),
      ],
      verify: (_) {
        verify(() => mockVerifyEmailUsecase.call(any())).called(1);
      },
    );
  });
}
