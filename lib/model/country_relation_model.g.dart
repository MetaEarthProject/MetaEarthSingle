// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_relation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountryRelationAdapter extends TypeAdapter<CountryRelation> {
  @override
  final int typeId = 3;

  @override
  CountryRelation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CountryRelation(
      id: fields[0] as int,
      countryCode: fields[1] as String,
      relationship: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CountryRelation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.countryCode)
      ..writeByte(2)
      ..write(obj.relationship);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryRelationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
