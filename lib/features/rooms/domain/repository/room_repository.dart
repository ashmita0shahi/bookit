import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/room_entity.dart';

abstract interface class IRoomRepository {
  /// Fetch all available rooms
  Future<Either<Failure, List<RoomEntity>>> getRooms();

  /// Fetch a specific room by its ID
  Future<Either<Failure, RoomEntity>> getRoomById(String id);
}
