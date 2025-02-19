import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final String id;
  final String user;
  final String room;
  final DateTime checkIn;
  final DateTime checkOut;
  final bool confirmed;

  const BookingEntity({
    required this.id,
    required this.user,
    required this.room,
    required this.checkIn,
    required this.checkOut,
    this.confirmed = false,
  });

    // const BookingEntity.empty()
    //   : id = '',
    //     user = '',
    //     room = '',
    //     checkIn = '',
    //     checkOut = ,
    //     confirmed = false; 

  @override
  List<Object?> get props => [id, user, room, checkIn, checkOut, confirmed];
}
