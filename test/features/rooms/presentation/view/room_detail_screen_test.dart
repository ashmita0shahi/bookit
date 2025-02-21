import 'package:bookit/features/rooms/domain/entity/room_entity.dart';
import 'package:bookit/features/rooms/presentation/view/room_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RoomEntity testRoom;

  setUp(() {
    testRoom = const RoomEntity(
      roomId: '1',
      name: 'Deluxe Room',
      type: 'Deluxe',
      price: 150.0,
      images: ['public/room1.jpg'],
      available: true,
      amenities: ['WiFi', 'Air Conditioning', 'TV'],
      description: '',
    );
  });

  Widget createWidgetUnderTest(RoomEntity room) {
    return MaterialApp(
      home: RoomDetailScreen(room: room),
    );
  }

  /// ✅ Test 1: Renders all UI elements correctly
  testWidgets('Renders all required widgets', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testRoom));

    expect(find.text(testRoom.name), findsOneWidget);
    expect(find.text('Type: ${testRoom.type}'), findsOneWidget);
    expect(find.text('Price: NRs. ${testRoom.price.toStringAsFixed(0)}'),
        findsOneWidget);
    expect(find.text('Available'), findsOneWidget);
  });

  /// ✅ Test 2: Displays correct room availability
  testWidgets('Shows correct availability status', (WidgetTester tester) async {
    final testRoomUnavailable = RoomEntity(
      roomId: testRoom.roomId,
      name: testRoom.name,
      type: testRoom.type,
      price: testRoom.price,
      images: testRoom.images,
      available: false, // Manually setting unavailable
      amenities: testRoom.amenities, description: '',
    );

    await tester.pumpWidget(createWidgetUnderTest(testRoomUnavailable));

    expect(find.text('Not Available'), findsOneWidget);
    expect(find.text('Available'), findsNothing);
  });

  /// ✅ Test 3: Handles missing images correctly
  testWidgets('Displays error icon when image fails to load',
      (WidgetTester tester) async {
    final testRoomNoImages = RoomEntity(
      roomId: testRoom.roomId,
      name: testRoom.name,
      type: testRoom.type,
      price: testRoom.price,
      images: const [], // No images
      available: testRoom.available,
      amenities: testRoom.amenities, description: '',
    );

    await tester.pumpWidget(createWidgetUnderTest(testRoomNoImages));

    expect(find.byIcon(Icons.error), findsOneWidget);
  });

  /// ✅ Test 4: Shows check-in and check-out date pickers
  testWidgets('Opens date picker when check-in button is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testRoom));

    await tester.tap(find.text('Choose Check-In Date'));
    await tester.pumpAndSettle();

    expect(find.byType(CalendarDatePicker), findsOneWidget);
  });

  testWidgets('Opens date picker when check-out button is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testRoom));

    await tester.tap(find.text('Choose Check-Out Date'));
    await tester.pumpAndSettle();

    expect(find.byType(CalendarDatePicker), findsOneWidget);
  });

  /// ✅ Test 5: Khalti payment button is visible when room is available
  testWidgets('Displays payment button when room is available',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(testRoom));

    expect(find.text('Pay with Khalti'), findsOneWidget);
  });

  /// ✅ Test 6: No payment button if room is unavailable
  testWidgets('Hides payment button when room is unavailable',
      (WidgetTester tester) async {
    final testRoomUnavailable = RoomEntity(
      roomId: testRoom.roomId,
      name: testRoom.name,
      type: testRoom.type,
      price: testRoom.price,
      images: testRoom.images,
      available: false,
      amenities: testRoom.amenities,
      description: '',
    );

    await tester.pumpWidget(createWidgetUnderTest(testRoomUnavailable));

    expect(find.text('Pay with Khalti'), findsNothing);
  });
}
