import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entity/room_entity.dart';
import '../../domain/repository/room_repository.dart';
import '../data_source/room_remote_data_source.dart';

class RoomRemoteRepository implements IRoomRepository {
  final RoomRemoteDataSource roomRemoteDataSource;

  RoomRemoteRepository({required this.roomRemoteDataSource});

  @override
  Future<Either<Failure, List<RoomEntity>>> getRooms() async {
    try {
      final rooms = await roomRemoteDataSource.getRooms();
      return Right(rooms);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RoomEntity>> getRoomById(String id) async {
    try {
      final room = await roomRemoteDataSource.getRoomById(id);
      return Right(room);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
