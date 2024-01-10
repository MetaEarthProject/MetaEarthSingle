import 'country_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CountryController {
  static final CountryController _instance = CountryController._internal();

  factory CountryController() => _instance;

  CountryController._internal();

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'countries_database.db');

    print('Database path: $path');

    return await openDatabase(
      path,
      version: 4,
      onCreate: (Database db, int version) async {
        print('Creating database and initializing tables.');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS countries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            code TEXT,
            name TEXT,
            population INTEGER,
            gdp INTEGER,
            government_system TEXT
          )
        ''');
        await insertSampleData(db);
      },
    );
  }

  Future<void> insertSampleData(Database db) async {
    List<Country> countryList = [
      Country(
        code: 'US',
        name: 'United States',
        population: 331002651,
        gdp: 21433225,
        governmentSystem: 'Federal Republic',
      ),
      Country(
        code: 'CN',
        name: 'China',
        population: 1444216107,
        gdp: 16978624,
        governmentSystem: 'Single-Party Socialist Republic',
      ),
      Country(
        code: 'JP',
        name: 'Japan',
        population: 126476461,
        gdp: 5501000,
        governmentSystem: 'Constitutional Monarchy',
      ),
      Country(
        code: 'DE',
        name: 'Germany',
        population: 83783942,
        gdp: 4470617,
        governmentSystem: 'Federal Republic',
      ),
      Country(
        code: 'FR',
        name: 'France',
        population: 65273511,
        gdp: 3038242,
        governmentSystem: 'Semi-Presidential Republic',
      ),
      Country(
        code: 'IN',
        name: 'India',
        population: 1393409038,
        gdp: 2875145,
        governmentSystem: 'Federal Parliamentary Democratic Republic',
      ),
      Country(
        code: 'GB',
        name: 'United Kingdom',
        population: 67886011,
        gdp: 2848276,
        governmentSystem: 'Constitutional Monarchy',
      ),
      Country(
        code: 'IT',
        name: 'Italy',
        population: 60461826,
        gdp: 2070371,
        governmentSystem: 'Parliamentary Republic',
      ),
      Country(
        code: 'CA',
        name: 'Canada',
        population: 37742154,
        gdp: 1908475,
        governmentSystem: 'Federal Parliamentary Democracy',
      ),
      Country(
        code: 'BR',
        name: 'Brazil',
        population: 212559417,
        gdp: 1839887,
        governmentSystem: 'Federal Republic',
      ),
      Country(
        code: 'KR',
        name: 'South Korea',
        population: 51269185,
        gdp: 1693207,
        governmentSystem: 'Unitary Presidential Republic',
      ),
    ];

    for (Country country in countryList) {
      await db.insert(
        'countries',
        country.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> insertCountry(Database db, Country country) async {
    await db.insert('countries', country.toMap());
  }

  Future<Country?> getCountryDetails(String countryCode) async {
    print('Querying country details for $countryCode');
    Database db = await initDatabase();
    List<Map<String, dynamic>> countryMapList = await db.query(
      'countries',
      where: 'code = ?',
      whereArgs: [countryCode],
    );

    if (countryMapList.isNotEmpty) {
      return Country.fromMap(countryMapList.first);
    }

    return null;
  }

  Future<List<Country>> getCountries() async {
    print('Querying all countries');
    Database db = await initDatabase();
    List<Map<String, dynamic>> countryMaps = await db.query('countries');

    return countryMaps.map((map) => Country.fromMap(map)).toList();
  }

  Future<void> resetDatabase() async {
    try {
      Database db = await initDatabase();
      print('Before deleting data');
      await db.delete('countries');
      print('After deleting data');
      await db.execute('VACUUM');
      print('Database reset complete in controller part.');
    } catch (e) {
      print('Error during database reset: $e');
    }
  }
}
