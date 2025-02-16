import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/use_case/get_room_by_id_usecase.dart';
import '../../domain/use_case/get_room_usecase.dart';
import 'room_event.dart';
import 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final GetRoomsUseCase getRoomsUseCase;
  final GetRoomByIdUseCase getRoomByIdUseCase;

  RoomBloc({
    required this.getRoomsUseCase,
    required this.getRoomByIdUseCase,
  }) : super(RoomInitial()) {
    on<GetRoomsEvent>(_onGetRoomsEvent);
    on<GetRoomByIdEvent>(_onGetRoomByIdEvent);
  }

  Future<void> _onGetRoomsEvent(
      GetRoomsEvent event, Emitter<RoomState> emit) async {
    emit(RoomLoading());
    final result = await getRoomsUseCase();
    result.fold(
      (failure) => emit(RoomError(message: _mapFailureToMessage(failure))),
      (rooms) => emit(RoomsLoaded(rooms: rooms)),
    );
  }

  Future<void> _onGetRoomByIdEvent(
      GetRoomByIdEvent event, Emitter<RoomState> emit) async {
    emit(RoomLoading());
    final result =
        await getRoomByIdUseCase(GetRoomByIdParams(roomId: event.roomId));
    result.fold(
      (failure) => emit(RoomError(message: _mapFailureToMessage(failure))),
      (room) => emit(RoomLoaded(room: room)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is LocalDatabaseFailure) {
      return "Failed to fetch data from local storage.";
    } else if (failure is ApiFailure) {
      return "Failed to fetch data from the server.";
    }
    return "Unexpected error occurred.";
  }
}
