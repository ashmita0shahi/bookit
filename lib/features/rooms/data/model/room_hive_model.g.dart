// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoomHiveModelAdapter extends TypeAdapter<RoomHiveModel> {
  @override
  final int typeId = 2;

  @override
  RoomHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoomHiveModel(
      roomId: fields[0] as String?,
      name: fields[1] as String,
      type: fields[2] as String,
      price: fields[3] as double,
      description: fields[4] as String,
      amenities: (fields[5] as List).cast<String>(),
      available: fields[6] as bool,
      images: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, RoomHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.roomId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.amenities)
      ..writeByte(6)
      ..write(obj.available)
      ..writeByte(7)
      ..write(obj.images);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
