import 'package:bloc_test/bloc_test.dart';
import 'package:bookit/features/rooms/domain/entity/room_entity.dart';
import 'package:bookit/features/rooms/presentation/view/room_list.dart';
import 'package:bookit/features/rooms/presentation/view_model/room_bloc.dart';
import 'package:bookit/features/rooms/presentation/view_model/room_event.dart';
import 'package:bookit/features/rooms/presentation/view_model/room_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ✅ Mock RoomBloc
class MockRoomBloc extends MockBloc<RoomEvent, RoomState> implements RoomBloc {}

void main() {
  late MockRoomBloc mockRoomBloc;

  setUp(() {
    mockRoomBloc = MockRoomBloc();
  });

  tearDown(() {
    mockRoomBloc.close();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<RoomBloc>.value(
        value: mockRoomBloc,
        child: child,
      ),
    );
  }

  group('RoomListScreen Widget Tests', () {
    final List<RoomEntity> testRooms = [
      const RoomEntity(
        roomId: '1',
        name: 'Deluxe Room',
        description: 'A luxurious deluxe room with a sea view.',
        type: 'Deluxe',
        price: 150.0,
        images: ['room1.jpg'],
        amenities: ['WiFi', 'Air Conditioning', 'TV'],
      ),
    ];

    // ✅ 1) Shows loading indicator when state is RoomLoading
    testWidgets('displays loading indicator when state is RoomLoading',
        (WidgetTester tester) async {
      when(() => mockRoomBloc.state).thenReturn(RoomLoading());

      await tester.pumpWidget(makeTestableWidget(const RoomListScreen()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // ✅ 2) Displays list of rooms when state is RoomsLoaded
    testWidgets('displays list of rooms when state is RoomsLoaded',
        (WidgetTester tester) async {
      when(() => mockRoomBloc.state).thenReturn(RoomsLoaded(rooms: testRooms));

      await tester.pumpWidget(makeTestableWidget(const RoomListScreen()));

      expect(find.text('Deluxe Room'), findsOneWidget);
      expect(find.text('NRs. 150'), findsOneWidget);
    });

    // ✅ 3) Displays error message when state is RoomError
    testWidgets('displays error message when state is RoomError',
        (WidgetTester tester) async {
      when(() => mockRoomBloc.state)
          .thenReturn(RoomError(message: "Failed to load rooms"));

      await tester.pumpWidget(makeTestableWidget(const RoomListScreen()));

      expect(find.text("Failed to load rooms"), findsOneWidget);
    });

    // ✅ 4) Displays "No rooms available" when room list is empty
    testWidgets(
        'displays "No rooms available" when state is RoomsLoaded with empty list',
        (WidgetTester tester) async {
      when(() => mockRoomBloc.state).thenReturn(RoomsLoaded(rooms: const []));

      await tester.pumpWidget(makeTestableWidget(const RoomListScreen()));

      expect(find.text('No rooms available.'), findsOneWidget);
    });
  });
}
