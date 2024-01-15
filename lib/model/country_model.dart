import 'package:hive/hive.dart';
part 'country_model.g.dart'; // Name of the TypeAdapter that will be generated

@HiveType(typeId: 0) // Unique identifier for this type
class Country extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String code;

  @HiveField(2)
  String name;

  @HiveField(3)
  int population;

  @HiveField(4)
  int gdp;

  @HiveField(5)
  String governmentSystem;

  // Additional
  Country({
    this.id,
    required this.code,
    required this.name,
    required this.population,
    required this.gdp,
    required this.governmentSystem,
  });
}
