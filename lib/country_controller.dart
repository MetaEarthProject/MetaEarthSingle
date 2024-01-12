import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'country_model.dart';

class CountryController {
  static final CountryController _instance = CountryController._internal();

  factory CountryController() => _instance;

  CountryController._internal();

  Future<void> initDatabase() async {
    final applicationDocumentsDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(applicationDocumentsDirectory.path);
    Hive.registerAdapter(CountryAdapter());
    await Hive.openBox<Country>('countries');
    await insertSampleData();
  }

  Future<void> insertSampleData() async {
    final countryBox = Hive.box<Country>('countries');
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
      await countryBox.put(country.code, country);
    }
  }

  Future<void> insertCountry(Country country) async {
    final countryBox = Hive.box<Country>('countries');
    await countryBox.put(country.code, country);
  }

  Future<Country?> getCountryDetails(String countryCode) async {
    final countryBox = Hive.box<Country>('countries');
    return countryBox.get(countryCode);
  }

  Future<List<Country>> getCountries() async {
    final countryBox = Hive.box<Country>('countries');
    return countryBox.values.toList();
  }

  Future<void> resetDatabase() async {
    final countryBox = Hive.box<Country>('countries');
    await countryBox.clear();
  }
}
