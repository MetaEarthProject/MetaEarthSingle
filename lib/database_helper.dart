import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'country_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    return await initDatabase();
  }

  Future<Database> initDatabase() async {
    print('Initialize database called');
    String path = join(await getDatabasesPath(), 'countries_database.db');

    Database db = await openDatabase(
      path,
      version: 4,
      onCreate: (Database db, int version) async {
        print('onCreate callback executed');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS countries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            code TEXT,
            name TEXT,
            population INTEGER,
            gdp REAL,
            government_system TEXT
          )
        ''');
        // Insert sample data
        await insertSampleData(db);
      },
    );

    // Check if the table is empty and insert data if needed
    List<Map<String, dynamic>> result = await db.query('countries');
    if (result.isEmpty) {
      print('Inserting sample data');
      await insertSampleData(db);
    }

    return db;
  }

  Future<void> insertSampleData(Database db) async {
    // Insert the sample country if the table is empty
    await insertCountry(
      db,
      Country(
        code: 'US',
        name: 'United States',
        population: 331002651,
        gdp: 21433225.0,
        governmentSystem: 'Federal Republic',
      ),
    );

    await insertCountry(
      db,
      Country(
        code: 'GB',
        name: 'United Kingdom the Great Britain',
        population: 67886011,
        gdp: 2848276.0,
        governmentSystem: 'Constitutional Monarchy',
      ),
    );
  }

  Future<void> insertCountry(Database db, Country country) async {
    await db.insert('countries', country.toMap());
  }

  Future<Country?> getCountryDetails(String countryCode) async {
    Database db = await database;
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
    Database db = await database;
    List<Map<String, dynamic>> countryMaps = await db.query('countries');

    return countryMaps.map((map) => Country.fromMap(map)).toList();
  }

  Future<void> resetDatabase() async {
    Database db = await database;
    await db.delete('countries');
  }
}
