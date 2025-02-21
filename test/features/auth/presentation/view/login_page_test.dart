import 'package:bloc_test/bloc_test.dart';
import 'package:bookit/features/auth/presentation/view/login_page.dart';
import 'package:bookit/features/auth/presentation/view/register_page.dart';
import 'package:bookit/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:bookit/features/home/presentation/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// ✅ Mock Dependencies
class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockLoginBloc mockLoginBloc;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockLoginBloc = MockLoginBloc();
    mockNavigatorObserver = MockNavigatorObserver();

    // ✅ Stub initial state
    when(() => mockLoginBloc.state).thenReturn(
      const LoginState(isLoading: false, isSuccess: false),
    );
  });

  /// ✅ Helper function to create widget under test
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<LoginBloc>.value(
        value: mockLoginBloc,
        child: LoginPage(),
      ),
      navigatorObservers: [mockNavigatorObserver],
    );
  }

  group('LoginPage Widget Tests', () {
    /// ✅ Test 1: Renders all required widgets
    testWidgets('Renders all required widgets', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });

    /// ✅ Test 2: Shows validation error when fields are empty
    testWidgets('Shows validation error when login fields are empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Log In'));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    /// ✅ Test 3: Triggers login event when form is valid
    testWidgets('Triggers login event when form is valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid email and password
      await tester.enterText(
          find.byType(TextFormField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');

      await tester.tap(find.text('Log In'));
      await tester.pump();

      // ✅ Verify event was added to the bloc
      verify(() => mockLoginBloc.add(
            any<LoginUserEvent>(), // Check if login event was triggered
          )).called(1);
    });

    /// ✅ Test 4: Shows loading indicator when login is in progress
    testWidgets('Shows loading indicator when login is in progress',
        (WidgetTester tester) async {
      when(() => mockLoginBloc.state).thenReturn(
        const LoginState(isLoading: true, isSuccess: false),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    /// ✅ Test 5: Navigates to HotelDetailPage on successful login
    testWidgets('Navigates to HotelDetailPage on successful login',
        (WidgetTester tester) async {
      when(() => mockLoginBloc.state).thenReturn(
        const LoginState(isLoading: false, isSuccess: true),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      verify(() => mockNavigatorObserver.didPush(any(), any())).called(1);
      expect(find.byType(HotelDetailPage), findsOneWidget);
    });

    /// ✅ Test 6: Navigates to RegisterPage when register button is clicked
    testWidgets('Navigates to RegisterPage when register button is clicked',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text("Haven't Registered Yet?"));
      await tester.pumpAndSettle();

      verify(() => mockNavigatorObserver.didPush(any(), any())).called(1);
      expect(find.byType(RegisterPage), findsOneWidget);
    });
  });
}
