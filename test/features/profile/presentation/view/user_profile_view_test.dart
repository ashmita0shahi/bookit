import 'package:bloc_test/bloc_test.dart';
import 'package:bookit/features/auth/domain/entity/auth_entity.dart';
import 'package:bookit/features/auth/presentation/view/login_page.dart';
import 'package:bookit/features/profile/presentation/view/user_profile_view.dart';
import 'package:bookit/features/profile/presentation/view_model/user_bloc.dart';
import 'package:bookit/features/profile/presentation/view_model/user_event.dart';
import 'package:bookit/features/profile/presentation/view_model/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// ✅ Mock Dependencies
class MockUserBloc extends MockBloc<UserEvent, UserState> implements UserBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockUserBloc mockUserBloc;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockUserBloc = MockUserBloc();
    mockNavigatorObserver = MockNavigatorObserver();

    // ✅ Stub initial state
    when(() => mockUserBloc.state).thenReturn(UserInitial());
  });

  /// ✅ Helper function to create the widget under test
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<UserBloc>.value(
        value: mockUserBloc,
        child: const ProfilePage(),
      ),
      navigatorObservers: [mockNavigatorObserver],
    );
  }

  group('ProfilePage Widget Tests', () {
    /// ✅ Test 1: Renders all required UI elements
    testWidgets('Renders all required UI elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text("Profile"), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    /// ✅ Test 2: Shows loading indicator when fetching user data
    testWidgets('Shows loading indicator when fetching user data',
        (WidgetTester tester) async {
      when(() => mockUserBloc.state).thenReturn(UserLoading());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    /// ✅ Test 3: Displays user profile data when loaded
    testWidgets('Displays user profile data when loaded',
        (WidgetTester tester) async {
      const testUser = AuthEntity(
        fullname: "John Doe",
        email: "johndoe@example.com",
        phoneNo: "1234567890",
        address: "123 Street, City",
        image: "/uploads/johndoe.png",
        password: '',
      );

      when(() => mockUserBloc.state).thenReturn(UserLoaded(testUser));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text("John Doe"), findsOneWidget);
      expect(find.text("johndoe@example.com"), findsOneWidget);
      expect(find.text("1234567890"), findsOneWidget);
      expect(find.text("123 Street, City"), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    /// ✅ Test 4: Shows error message when fetching fails
    testWidgets('Shows error message when fetching user fails',
        (WidgetTester tester) async {
      when(() => mockUserBloc.state)
          .thenReturn(UserError("Failed to load profile"));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text("Error: Failed to load profile"), findsOneWidget);
    });

    /// ✅ Test 5: Clicking logout button navigates to login page
    testWidgets('Navigates to LoginPage when logout button is clicked',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      verify(() => mockNavigatorObserver.didPush(any(), any())).called(1);
      expect(find.byType(LoginPage), findsOneWidget);
    });

    /// ✅ Test 6: Simulates flipping the device to trigger logout
    testWidgets('Logs out when device is flipped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // ✅ Simulate gyroscope flipping
      await tester.binding
          .setSurfaceSize(const Size(600, 300)); // Simulate tilt
      await tester.pumpAndSettle();

      verify(() => mockNavigatorObserver.didPush(any(), any())).called(1);
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
