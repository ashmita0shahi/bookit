import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/room_entity.dart';
import '../repository/room_repository.dart';

class GetRoomByIdParams extends Equatable {
  final String roomId;

  const GetRoomByIdParams({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}

class GetRoomByIdUseCase
    implements UsecaseWithParams<RoomEntity, GetRoomByIdParams> {
  final IRoomRepository roomRepository;

  GetRoomByIdUseCase({required this.roomRepository});

  @override
  Future<Either<Failure, RoomEntity>> call(GetRoomByIdParams params) async {
    return await roomRepository.getRoomById(params.roomId);
  }
}
