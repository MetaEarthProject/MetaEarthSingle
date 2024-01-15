// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'defense.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MilitaryAdapter extends TypeAdapter<Military> {
  @override
  final int typeId = 2;

  @override
  Military read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Military(
      id: fields[0] as int,
      countryCode: fields[1] as String,
      infantry: fields[2] as int?,
      tank: fields[3] as int?,
      airforce: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Military obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.countryCode)
      ..writeByte(2)
      ..write(obj.infantry)
      ..writeByte(3)
      ..write(obj.tank)
      ..writeByte(4)
      ..write(obj.airforce);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MilitaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
