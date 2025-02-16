import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/room_entity.dart'; // Import RoomEntity

part 'room_api_model.g.dart';

@JsonSerializable()
class RoomApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? roomId;
  final String name;
  final String type;
  final double price;
  final String description;
  final List<String> amenities;
  final bool available;
  final List<String> images;

  const RoomApiModel({
    this.roomId,
    required this.name,
    required this.type,
    required this.price,
    required this.description,
    required this.amenities,
    required this.available,
    required this.images,
  });

  const RoomApiModel.empty()
      : roomId = '',
        name = '',
        type = '',
        price = 0.0,
        description = '',
        amenities = const [],
        available = false,
        images = const [];

  // From JSON
  factory RoomApiModel.fromJson(Map<String, dynamic> json) =>
      _$RoomApiModelFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$RoomApiModelToJson(this);

  // Convert RoomApiModel to RoomEntity
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
