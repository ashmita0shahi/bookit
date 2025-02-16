import 'package:equatable/equatable.dart';

class RoomEntity extends Equatable {
  final String? roomId; // ID might be optional
  final String name;
  final String type; // Single, Double, Suite
  final double price;
  final String description;
  final List<String> amenities; // List of amenities like Wi-Fi, TV, etc.
  final bool available;
  final List<String> images; // List of image URLs

  const RoomEntity({
    this.roomId,
    required this.name,
    required this.type,
    required this.price,
    required this.description,
    required this.amenities,
    this.available = true,
    this.images = const [],
  });

  const RoomEntity.empty()
      : roomId = '_empty.roomId',
        name = '_empty.name',
        type = '_empty.type',
        price = 0.0,
        description = '_empty.description',
        amenities = const [],
        available = false,
        images = const [];

  @override
  List<Object?> get props => [
        roomId,
        name,
        type,
        price,
        description,
        amenities,
        available,
        images,
      ];
}
