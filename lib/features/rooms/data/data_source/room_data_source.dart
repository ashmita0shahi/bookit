import '../../domain/entity/room_entity.dart';

abstract interface class IRoomDataSource {
  /// Fetch all available rooms
  Future<List<RoomEntity>> getRooms();

  /// Fetch a room by its ID
  Future<RoomEntity> getRoomById(String id);
}
