// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountryAdapter extends TypeAdapter<Country> {
  @override
  final int typeId = 0;

  @override
  Country read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Country(
      id: fields[0] as int?,
      code: fields[1] as String,
      name: fields[2] as String,
      population: fields[3] as int,
      gdp: fields[4] as int,
      governmentSystem: fields[5] as String,
      stateBudget: fields[6] as int,
      unemploymentRate: fields[7] as double,
      interestRate: fields[8] as double,
      inflationRate: fields[9] as double,
      taxRate: fields[10] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Country obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.population)
      ..writeByte(4)
      ..write(obj.gdp)
      ..writeByte(5)
      ..write(obj.governmentSystem)
      ..writeByte(6)
      ..write(obj.stateBudget)
      ..writeByte(7)
      ..write(obj.unemploymentRate)
      ..writeByte(8)
      ..write(obj.interestRate)
      ..writeByte(9)
      ..write(obj.inflationRate)
      ..writeByte(10)
      ..write(obj.taxRate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
