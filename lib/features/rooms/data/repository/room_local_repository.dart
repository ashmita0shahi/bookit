import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entity/room_entity.dart';
import '../../domain/repository/room_repository.dart';
import '../data_source/room_local_data_source.dart';

class RoomLocalRepository implements IRoomRepository {
  final RoomLocalDataSource roomLocalDataSource;

  RoomLocalRepository({required this.roomLocalDataSource});

  @override
  Future<Either<Failure, List<RoomEntity>>> getRooms() async {
    try {
      final rooms = await roomLocalDataSource.getRooms();
      return Right(rooms);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RoomEntity>> getRoomById(String id) async {
    try {
      final room = await roomLocalDataSource.getRoomById(id);
      return Right(room);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
