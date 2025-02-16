import 'package:dartz/dartz.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/room_entity.dart';
import '../repository/room_repository.dart';

class GetRoomsUseCase implements UsecaseWithoutParams<List<RoomEntity>> {
  final IRoomRepository roomRepository;

  GetRoomsUseCase({required this.roomRepository});

  @override
  Future<Either<Failure, List<RoomEntity>>> call() async {
    return await roomRepository.getRooms();
  }
}
