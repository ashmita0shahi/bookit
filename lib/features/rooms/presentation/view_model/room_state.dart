import 'package:equatable/equatable.dart';

import '../../domain/entity/room_entity.dart';

abstract class RoomState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomsLoaded extends RoomState {
  final List<RoomEntity> rooms;

  RoomsLoaded({required this.rooms});

  @override
  List<Object?> get props => [rooms];
}

class RoomLoaded extends RoomState {
  final RoomEntity room;

  RoomLoaded({required this.room});

  @override
  List<Object?> get props => [room];
}

class RoomError extends RoomState {
  final String message;

  RoomError({required this.message});

  @override
  List<Object?> get props => [message];
}
