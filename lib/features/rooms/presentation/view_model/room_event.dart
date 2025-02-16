import 'package:equatable/equatable.dart';

abstract class RoomEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetRoomsEvent extends RoomEvent {}

class GetRoomByIdEvent extends RoomEvent {
  final String roomId;

  GetRoomByIdEvent({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}
