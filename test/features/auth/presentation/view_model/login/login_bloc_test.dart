import 'package:bloc_test/bloc_test.dart';
import 'package:bookit/core/error/failure.dart';
import 'package:bookit/features/auth/domain/use_case/login_usecase.dart';
import 'package:bookit/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:bookit/features/home/presentation/view_model/home_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockHomeCubit extends Mock implements HomeCubit {}

void main() {
  late MockLoginUseCase loginUseCase;
  late MockHomeCubit homeCubit;
  late LoginBloc loginBloc;

  setUp(() {
    loginUseCase = MockLoginUseCase();
    homeCubit = MockHomeCubit();
    loginBloc = LoginBloc(loginUseCase: loginUseCase, homeCubit: homeCubit);
  });

  tearDown(() {
    loginBloc.close();
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testToken = 'mock_jwt_token';

  group('LoginBloc Tests', () {
    test('Initial state should be LoginState.initial()', () {
      expect(loginBloc.state, LoginState.initial());
    });

    blocTest<LoginBloc, LoginState>(
      'Emits [Loading, Success] when login is successful',
      build: () {
        when(() => loginUseCase(any()))
            .thenAnswer((_) async => const Right(testToken));
        return loginBloc;
      },
      act: (bloc) => bloc.add(
        LoginUserEvent(
          context: MockBuildContext(),
          username: testEmail,
          password: testPassword,
        ),
      ),
      expect: () => [
        const LoginState(isLoading: true, isSuccess: false),
        const LoginState(isLoading: false, isSuccess: true),
      ],
      verify: (_) {
        verify(() => loginUseCase(
                const LoginParams(email: testEmail, password: testPassword)))
            .called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'Emits [Loading, Failure] when login fails due to invalid credentials',
      build: () {
        when(() => loginUseCase(any())).thenAnswer((_) async =>
            const Left(ApiFailure(message: 'Invalid Credentials')));
        return loginBloc;
      },
      act: (bloc) => bloc.add(
        LoginUserEvent(
          context: MockBuildContext(),
          username: testEmail,
          password: testPassword,
        ),
      ),
      expect: () => [
        const LoginState(isLoading: true, isSuccess: false),
        const LoginState(isLoading: false, isSuccess: false),
      ],
      verify: (_) {
        verify(() => loginUseCase(
                const LoginParams(email: testEmail, password: testPassword)))
            .called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'Emits [Loading, Failure] when login fails due to server error',
      build: () {
        when(() => loginUseCase(any())).thenAnswer((_) async =>
            const Left(ApiFailure(message: 'Internal Server Error')));
        return loginBloc;
      },
      act: (bloc) => bloc.add(
        LoginUserEvent(
          context: MockBuildContext(),
          username: testEmail,
          password: testPassword,
        ),
      ),
      expect: () => [
        const LoginState(isLoading: true, isSuccess: false),
        const LoginState(isLoading: false, isSuccess: false),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'Navigates to register screen when NavigateRegisterScreenEvent is added',
      build: () => loginBloc,
      act: (bloc) => bloc.add(
        NavigateRegisterScreenEvent(
          context: MockBuildContext(),
          destination: Container(),
        ),
      ),
      expect: () => [],
    );
  });
}

class MockBuildContext extends Mock implements BuildContext {}
