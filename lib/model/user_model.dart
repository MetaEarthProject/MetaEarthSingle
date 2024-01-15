import 'package:hive/hive.dart';
part 'user_model.g.dart'; // Name of the TypeAdapter that will be generated

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? countryCode;

  User({
    this.id,
    this.countryCode,
  });
}
