import 'package:bloc_test/bloc_test.dart';
import 'package:bookit/core/error/failure.dart';
import 'package:bookit/features/rooms/domain/entity/room_entity.dart';
import 'package:bookit/features/rooms/domain/use_case/get_room_by_id_usecase.dart';
import 'package:bookit/features/rooms/domain/use_case/get_room_usecase.dart';
import 'package:bookit/features/rooms/presentation/view_model/room_bloc.dart';
import 'package:bookit/features/rooms/presentation/view_model/room_event.dart';
import 'package:bookit/features/rooms/presentation/view_model/room_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ✅ Mock Dependencies
class MockGetRoomsUseCase extends Mock implements GetRoomsUseCase {}

class MockGetRoomByIdUseCase extends Mock implements GetRoomByIdUseCase {}

void main() {
  late RoomBloc roomBloc;
  late MockGetRoomsUseCase mockGetRoomsUseCase;
  late MockGetRoomByIdUseCase mockGetRoomByIdUseCase;

  setUp(() {
    mockGetRoomsUseCase = MockGetRoomsUseCase();
    mockGetRoomByIdUseCase = MockGetRoomByIdUseCase();
    roomBloc = RoomBloc(
      getRoomsUseCase: mockGetRoomsUseCase,
      getRoomByIdUseCase: mockGetRoomByIdUseCase,
    );

    // ✅ Register fallback values for mocktail
    registerFallbackValue(const GetRoomByIdParams(roomId: '1'));
  });

  tearDown(() {
    roomBloc.close();
  });

  group('RoomBloc Tests', () {
    const testRoom = RoomEntity(
      roomId: '1',
      name: 'Deluxe Room',
      description: 'A luxurious deluxe room with a sea view.',
      type: 'Deluxe',
      price: 150.0,
      images: ['room1.jpg'],
      amenities: ['WiFi', 'Air Conditioning', 'TV'],
    );

    final List<RoomEntity> testRooms = [testRoom];

    // ✅ 1) Successful fetch of multiple rooms
    blocTest<RoomBloc, RoomState>(
      'emits [RoomLoading, RoomsLoaded] when GetRoomsEvent is added',
      build: () {
        when(() => mockGetRoomsUseCase()).thenAnswer(
          (_) async => Right(testRooms),
        );
        return roomBloc;
      },
      act: (bloc) => bloc.add(GetRoomsEvent()),
      expect: () => [
        RoomLoading(),
        RoomsLoaded(rooms: testRooms),
      ],
    );

    // ✅ 2) Failed fetch of multiple rooms (API failure)
    blocTest<RoomBloc, RoomState>(
      'emits [RoomLoading, RoomError] when GetRoomsEvent fails',
      build: () {
        when(() => mockGetRoomsUseCase()).thenAnswer(
          (_) async => const Left(ApiFailure(message: "Failed to fetch rooms")),
        );
        return roomBloc;
      },
      act: (bloc) => bloc.add(GetRoomsEvent()),
      expect: () => [
        RoomLoading(),
        RoomError(message: "Failed to fetch data from the server."),
      ],
    );

    // ✅ 3) Successful fetch of an empty list of rooms
    blocTest<RoomBloc, RoomState>(
      'emits [RoomLoading, RoomsLoaded] with an empty list when GetRoomsEvent returns no rooms',
      build: () {
        when(() => mockGetRoomsUseCase()).thenAnswer(
          (_) async => const Right(<RoomEntity>[]), // Empty list
        );
        return roomBloc;
      },
      act: (bloc) => bloc.add(GetRoomsEvent()),
      expect: () => [
        RoomLoading(),
        RoomsLoaded(rooms: const []), // Empty rooms
      ],
    );

    // ✅ 4) Successful fetch of a room by ID
    blocTest<RoomBloc, RoomState>(
      'emits [RoomLoading, RoomLoaded] when GetRoomByIdEvent is added',
      build: () {
        when(() => mockGetRoomByIdUseCase(any()))
            .thenAnswer((_) async => const Right(testRoom));
        return roomBloc;
      },
      act: (bloc) => bloc.add(GetRoomByIdEvent(roomId: '1')),
      expect: () => [
        RoomLoading(),
        RoomLoaded(room: testRoom),
      ],
    );

    // ✅ 5) Failed fetch of a room by ID (API failure)
    blocTest<RoomBloc, RoomState>(
      'emits [RoomLoading, RoomError] when GetRoomByIdEvent fails',
      build: () {
        when(() => mockGetRoomByIdUseCase(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: "Room not found")),
        );
        return roomBloc;
      },
      act: (bloc) => bloc.add(GetRoomByIdEvent(roomId: '99')),
      expect: () => [
        RoomLoading(),
        RoomError(message: "Failed to fetch data from the server."),
      ],
    );

    // ✅ 6) LocalDatabaseFailure when fetching a room by ID
    blocTest<RoomBloc, RoomState>(
      'emits [RoomLoading, RoomError] with local storage message on LocalDatabaseFailure',
      build: () {
        when(() => mockGetRoomByIdUseCase(any())).thenAnswer(
          (_) async =>
              const Left(LocalDatabaseFailure(message: "No local data")),
        );
        return roomBloc;
      },
      act: (bloc) => bloc.add(GetRoomByIdEvent(roomId: '2')),
      expect: () => [
        RoomLoading(),
        RoomError(message: "Failed to fetch data from local storage."),
      ],
    );
  });
}
