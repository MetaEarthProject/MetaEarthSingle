import 'package:hive/hive.dart';
import 'package:collection/collection.dart';
part 'country_relation_model.g.dart'; // Name of the TypeAdapter that will be generated

@HiveType(typeId: 3) // Unique identifier for this type
class CountryRelation extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String countryCode;

  @HiveField(2)
  int relationship;

  CountryRelation({
    required this.id,
    required this.countryCode,
    this.relationship = 0,
  });

  static const String boxName = 'countryRelations';

  static Future<Box<CountryRelation>> get _box async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<CountryRelation>(boxName);
    } else {
      return Hive.box<CountryRelation>(boxName);
    }
  }

  static Future<void> addRelation(CountryRelation relation) async {
    var box = await _box;
    await box.add(relation);
  }

  static Future<List<CountryRelation>> getRelations() async {
    var box = await _box;
    return box.values.toList();
  }

  static Future<CountryRelation?> getRelation(int id) async {
    var box = await _box;
    return box.get(id);
  }

  static Future<void> updateRelation(int id, CountryRelation relation) async {
    var box = await _box;
    await box.put(id, relation);
  }

  static Future<void> deleteRelation(int id) async {
    var box = await _box;
    await box.delete(id);
  }

  static Future<CountryRelation?> getRelationByCountryCode(
      String countryCode) async {
    var box = await _box;
    return box.values
        .firstWhereOrNull((relation) => relation.countryCode == countryCode);
  }
}
