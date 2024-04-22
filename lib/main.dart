import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:intl/intl.dart';
import 'package:meta_earth_single_mode/model/defense.dart';
import 'package:meta_earth_single_mode/model/country_relation_model.dart';
import 'package:provider/provider.dart';
import '/model/country_model.dart';
import '/model/user_model.dart';
import 'country_controller.dart';
import 'package:meta_earth_single_mode/world_map_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing app');

  await HiveController.initHive();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CountryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CountryColorsNotifier(),
        ),
      ],
      child: const MaterialApp(
        home: WorldMapPage(selectedCountry: 'US'),
      ),
    ),
  );
}

class HiveController {
  static void registerTA<T extends HiveObject>(int id, TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(id)) {
      Hive.registerAdapter<T>(adapter);
    }
  }

  static Future<void> initHive() async {
    final applicationDocumentsDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(applicationDocumentsDirectory.path);

    registerTA(0, CountryAdapter());
    registerTA(1, UserAdapter());
    registerTA(2, MilitaryAdapter());
    registerTA(3, CountryRelationAdapter());

    final countryController = CountryController();
    await countryController.initDatabase();
    await Hive.openBox<User>('users');
    await Hive.openBox<int>('gameTurn');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Choose your country'),
        ),
        body:
            const CountryDropdown(), // Assuming you've renamed it to CountryDropdown
      ),
    );
  }
}

class CountryDropdown extends StatefulWidget {
  const CountryDropdown({super.key});

  @override
  _CountryDropdownState createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  String selectedCountry = 'US'; // Default country

  late Map<String, String> selectedCountryDetails;

  @override
  void initState() {
    super.initState();
    selectedCountryDetails = {};
    updateCountryDetails(selectedCountry);
  }

  Future<void> updateCountryDetails(String countryCode) async {
    print('Updating country details for $countryCode');

    Country? selectedCountry = Hive.box<Country>('countries').get(countryCode);
    Military? selectedMilitary =
        Hive.box<Military>('military').get(countryCode);

    if (selectedCountry != null) {
      setState(() {
        selectedCountryDetails = {
          'Population': selectedCountry.population.toString(),
          'GDP': selectedCountry.gdp.toString(),
          'Government': selectedCountry.governmentSystem,
        };
        if (selectedMilitary != null) {
          selectedCountryDetails.addAll({
            'Infantry':
                NumberFormat.decimalPattern().format(selectedMilitary.infantry),
            'Tank': NumberFormat.decimalPattern().format(selectedMilitary.tank),
            'Airforce':
                NumberFormat.decimalPattern().format(selectedMilitary.airforce),
          });
        }
      });
    }
  }

  void onCountrySelected(String? value) async {
    if (value != null) {
      setState(() {
        selectedCountry = value;
      });

      await updateCountryDetails(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final countryBox = Hive.box<Country>('countries');
    final countries = countryBox.values.toList();

    if (countries.isEmpty) {
      return const Center(
        child: Text('No countries available.'),
      );
    }
    print('Countries: $countries');

    List<DropdownMenuItem<String>> countryList = countries
        .map((country) => DropdownMenuItem<String>(
              value: country.code,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CountryFlag.fromCountryCode(
                    country.code,
                    height: 30,
                    width: 40,
                    borderRadius: 8,
                  ),
                  const SizedBox(width: 10),
                  Text(country.name),
                ],
              ),
            ))
        .toList();
    return Column(
      children: [
        const SizedBox(height: 20),
        DropdownButton<String>(
          value: selectedCountry,
          onChanged: onCountrySelected,
          isExpanded: true,
          items: countryList,
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: selectedCountryDetails.entries
              .map((entry) => Text(
                  '${entry.key}: ${entry.key == 'GDP' ? '\$' : ''}${entry.key == 'Population' || entry.key == 'GDP' ? NumberFormat.decimalPattern().format(int.parse(entry.value)) : entry.value}\n'))
              .toList(),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            print('Selected country: $selectedCountry');

            final userBox = Hive.box<User>('users');
            final user = User(id: 1, countryCode: selectedCountry);
            await userBox.put(user.id, user);
            print('user.id: ${user.id}');
            print('user.countryCode: ${user.countryCode}');

            // Use a separate BuildContext that is still valid after the async gap
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WorldMapPage(selectedCountry: selectedCountry),
                ),
              );
            });
          },
          child: const Text('Select this country'),
        ),
      ],
    );
  }
}
