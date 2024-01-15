import 'package:hive/hive.dart';
part 'defense.g.dart'; // Name of the TypeAdapter that will be generated

@HiveType(typeId: 2)
class Military extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String countryCode;

  @HiveField(2)
  int? infantry;

  @HiveField(3)
  int? tank;

  @HiveField(4)
  int? airforce;

  Military({
    required this.id,
    required this.countryCode,
    this.infantry,
    this.tank,
    this.airforce,
  });
}
