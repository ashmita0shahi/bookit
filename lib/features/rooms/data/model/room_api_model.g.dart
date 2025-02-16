// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomApiModel _$RoomApiModelFromJson(Map<String, dynamic> json) => RoomApiModel(
      roomId: json['_id'] as String?,
      name: json['name'] as String,
      type: json['type'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      amenities:
          (json['amenities'] as List<dynamic>).map((e) => e as String).toList(),
      available: json['available'] as bool,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$RoomApiModelToJson(RoomApiModel instance) =>
    <String, dynamic>{
      '_id': instance.roomId,
      'name': instance.name,
      'type': instance.type,
      'price': instance.price,
      'description': instance.description,
      'amenities': instance.amenities,
      'available': instance.available,
      'images': instance.images,
    };
