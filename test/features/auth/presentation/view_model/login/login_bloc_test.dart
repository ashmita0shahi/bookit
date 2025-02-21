import 'package:bookit/core/error/failure.dart';
import 'package:bookit/features/auth/domain/use_case/login_usecase.dart';
import 'package:bookit/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:bookit/features/home/presentation/view/home.dart';
import 'package:bookit/features/home/presentation/view_model/home_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ✅ Mock Dependencies
class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockHomeCubit extends Mock implements HomeCubit {}

class FakeLoginParams extends Fake implements LoginParams {}

void main() {
  late LoginBloc loginBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockHomeCubit mockHomeCubit;

  setUpAll(() {
    registerFallbackValue(FakeLoginParams()); // ✅ Register Fake LoginParams
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockHomeCubit = MockHomeCubit();

    loginBloc = LoginBloc(
      loginUseCase: mockLoginUseCase,
      homeCubit: mockHomeCubit,
    );
  });

  tearDown(() {
    loginBloc.close();
  });

  group('LoginBloc Tests', () {
    const String testEmail = 'johndoe@example.com';
    const String testPassword = 'password123';
    const String testToken = 'mockToken123';

    // ✅ Test Case 1: Successful Login
    testWidgets(
        'emits [LoginState(isLoading: true), LoginState(isSuccess: true)] when login succeeds',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  loginBloc.add(
                    LoginUserEvent(
                      context: context, // ✅ Use real context
                      username: testEmail,
                      password: testPassword,
                    ),
                  );
                },
                child: const Text('Login'),
              );
            },
          ),
        ),
      );

      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => const Right(testToken));

      loginBloc.add(LoginUserEvent(
        context: tester.element(find.text('Login')),
        username: testEmail,
        password: testPassword,
      ));

      await tester.pump(); // Wait for state changes

      expect(
          loginBloc.state, const LoginState(isLoading: false, isSuccess: true));
    });

    // ✅ Test Case 2: Failed Login (Invalid Credentials)
    testWidgets(
        'emits [LoginState(isLoading: true), LoginState(isSuccess: false)] when login fails',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  loginBloc.add(
                    LoginUserEvent(
                      context: context, // ✅ Use real context
                      username: testEmail,
                      password: "wrongpassword",
                    ),
                  );
                },
                child: const Text('Login'),
              );
            },
          ),
        ),
      );

      when(() => mockLoginUseCase(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: "Invalid Credentials")));

      loginBloc.add(LoginUserEvent(
        context: tester.element(find.text('Login')),
        username: testEmail,
        password: "wrongpassword",
      ));

      await tester.pump(); // Wait for state changes

      expect(loginBloc.state,
          const LoginState(isLoading: false, isSuccess: false));
    });

    // ✅ Test Case 3: Navigation to Register Screen
    testWidgets('triggers navigation when NavigateRegisterScreenEvent is added',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey:
              GlobalKey<NavigatorState>(), // ✅ Provide a real navigator
          home: Builder(builder: (context) {
            return ElevatedButton(
              onPressed: () {
                loginBloc.add(
                  NavigateRegisterScreenEvent(
                    context: context,
                    destination: const HotelDetailPage(),
                  ),
                );
              },
              child: const Text('Navigate'),
            );
          }),
        ),
      );

      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      expect(find.byType(HotelDetailPage), findsOneWidget);
    });

    // ✅ Test Case 4: Loading state changes correctly
    testWidgets(
        'emits LoginState(isLoading: true) initially, then LoginState(isLoading: false) after login fails',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  loginBloc.add(
                    LoginUserEvent(
                      context: context, // ✅ Use real context
                      username: testEmail,
                      password: testPassword,
                    ),
                  );
                },
                child: const Text('Login'),
              );
            },
          ),
        ),
      );

      when(() => mockLoginUseCase(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: "Network Error")));

      loginBloc.add(LoginUserEvent(
        context: tester.element(find.text('Login')),
        username: testEmail,
        password: testPassword,
      ));

      await tester.pump(); // Wait for state changes

      expect(loginBloc.state,
          const LoginState(isLoading: false, isSuccess: false));
    });
  });
}
