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

  @HiveField(6)
  int stateBudget;

  @HiveField(7)
  double unemploymentRate;

  @HiveField(8)
  double interestRate;

  @HiveField(9)
  double inflationRate;

  @HiveField(10)
  double taxRate;

  Country({
    this.id,
    required this.code,
    required this.name,
    required this.population,
    required this.gdp,
    required this.governmentSystem,
    required this.stateBudget,
    required this.unemploymentRate,
    required this.interestRate,
    required this.inflationRate,
    required this.taxRate,
  });
}
