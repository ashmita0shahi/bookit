import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entity/room_entity.dart';

part 'room_hive_model.g.dart';

@HiveType(typeId: 2) // Replace 1 with your unique typeId for Hive
class RoomHiveModel extends Equatable {
  @HiveField(0)
  final String? roomId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final double price;
  @HiveField(4)
  final String description;
  @HiveField(5)
  final List<String> amenities;
  @HiveField(6)
  final bool available;
  @HiveField(7)
  final List<String> images;

  RoomHiveModel({
    String? roomId,
    required this.name,
    required this.type,
    required this.price,
    required this.description,
    required this.amenities,
    this.available = true,
    this.images = const [],
  }) : roomId = roomId ?? const Uuid().v4();

  const RoomHiveModel.initial()
      : roomId = '',
        name = '',
        type = '',
        price = 0.0,
        description = '',
        amenities = const [],
        available = false,
        images = const [];

  // From Entity
  factory RoomHiveModel.fromEntity(RoomEntity entity) {
    return RoomHiveModel(
      roomId: entity.roomId,
      name: entity.name,
      type: entity.type,
      price: entity.price,
      description: entity.description,
      amenities: entity.amenities,
      available: entity.available,
      images: entity.images,
    );
  }

  // To Entity
  RoomEntity toEntity() {
    return RoomEntity(
      roomId: roomId,
      name: name,
      type: type,
      price: price,
      description: description,
      amenities: amenities,
      available: available,
      images: images,
    );
  }

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
