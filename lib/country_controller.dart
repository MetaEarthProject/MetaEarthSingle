import 'package:hive/hive.dart';
import '/model/country_model.dart';
import '/model/defense.dart';

class CountryController {
  static final CountryController _instance = CountryController._internal();

  factory CountryController() => _instance;

  CountryController._internal();

  Future<void> initDatabase() async {
    await insertSampleData();
    await insertMilitaryData();
  }

  Future<void> insertSampleData() async {
    await Hive.openBox<Country>('countries');
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

  Future<void> insertMilitaryData() async {
    List<Military> militaryList = [
      Military(
        id: 1,
        countryCode: 'US',
        infantry: 541291,
        tank: 5500,
        airforce: 13000,
      ),
      Military(
        id: 2,
        countryCode: 'CN',
        infantry: 2100000,
        tank: 3500,
        airforce: 123000,
      ),
      Military(
        id: 3,
        countryCode: 'JP',
        infantry: 225000,
        tank: 700,
        airforce: 1500,
      ),
      Military(
        id: 4,
        countryCode: 'DE',
        infantry: 183000,
        tank: 400,
        airforce: 700,
      ),
      Military(
        id: 5,
        countryCode: 'FR',
        infantry: 205000,
        tank: 400,
        airforce: 1100,
      ),
      Military(
        id: 6,
        countryCode: 'IN',
        infantry: 1392000,
        tank: 4500,
        airforce: 2100,
      ),
      Military(
        id: 7,
        countryCode: 'GB',
        infantry: 150000,
        tank: 200,
        airforce: 900,
      ),
      Military(
        id: 8,
        countryCode: 'IT',
        infantry: 180000,
        tank: 200,
        airforce: 800,
      ),
      Military(
        id: 9,
        countryCode: 'CA',
        infantry: 65000,
        tank: 80,
        airforce: 400,
      ),
      Military(
        id: 10,
        countryCode: 'BR',
        infantry: 334000,
        tank: 400,
        airforce: 700,
      ),
      Military(
        id: 11,
        countryCode: 'KR',
        infantry: 465000,
        tank: 2300,
        airforce: 1400,
      ),
    ];

    await Hive.openBox<Military>('military');
    final militaryBox = Hive.box<Military>('military');

    for (Military military in militaryList) {
      await militaryBox.put(military.countryCode, military);
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
}
