import 'package:bookit/features/rooms/domain/entity/room_entity.dart';

import '../../../../core/network/hive_service.dart';
import 'room_data_source.dart';

class RoomLocalDataSource implements IRoomDataSource {
  final HiveService hiveService;

  RoomLocalDataSource({required this.hiveService});

  @override
  Future<List<RoomEntity>> getRooms() async {
    try {
      final rooms = await hiveService.getAllRooms(); // Retrieve all rooms
      return rooms
          .map((room) => room.toEntity())
          .toList(); // Convert to entity list
    } catch (e) {
      throw Exception('Failed to fetch rooms from local storage: $e');
    }
  }

  @override
  Future<RoomEntity> getRoomById(String id) async {
    try {
      final room = await hiveService.getRoomById(id);
      if (room == null) {
        throw Exception('Room not found');
      }
      return room.toEntity(); // Convert to RoomEntity
    } catch (e) {
      throw Exception('Failed to fetch room from local storage: $e');
    }
  }
}
