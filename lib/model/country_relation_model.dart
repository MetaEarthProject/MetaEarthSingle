import 'package:hive/hive.dart';
part 'country_relation_model.g.dart';

@HiveType(typeId: 3) // Unique identifier for this type
class CountryRelation extends HiveObject {
  @HiveField(0)
  String countryCode;

  @HiveField(1)
  int relationship;

  CountryRelation({
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
    await box.put(relation.countryCode, relation);
  }

  static Future<List<CountryRelation>> getRelations() async {
    var box = await _box;
    return box.values.toList();
  }

  static Future<CountryRelation?> getRelation(String countryCode) async {
    var box = await _box;
    return box.get(countryCode);
  }

  static Future<void> updateRelation(
      String countryCode, CountryRelation relation) async {
    var box = await _box;
    await box.put(countryCode, relation);
  }

  static Future<void> deleteRelation(String countryCode) async {
    var box = await _box;
    await box.delete(countryCode);
  }

  static Future<int?> getRelationshipByCountryCode(String countryCode) async {
    var box = await _box;
    return box.get(countryCode)?.relationship;
  }
}
