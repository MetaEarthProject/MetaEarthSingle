import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'country_controller.dart';
import 'country_model.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing app');
  final applicationDocumentsDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(applicationDocumentsDirectory.path);
  Hive.registerAdapter(CountryAdapter());
  await Hive.openBox<Country>('countries');

  // Insert sample data
  final countryController = CountryController();
  await countryController.insertSampleData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const CountryDropdown({Key? key}) : super(key: key);

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

    if (selectedCountry != null) {
      setState(() {
        selectedCountryDetails = {
          'Population': selectedCountry.population.toString(),
          'GDP': selectedCountry.gdp.toString(),
          'Government': selectedCountry.governmentSystem,
        };
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

    // Sort the countries by name in ascending order
    // countries.sort((a, b) => a.name.compareTo(b.name));

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
          onPressed: () {
            print('Selected country: $selectedCountry');
          },
          child: const Text('Select this country'),
        ),
      ],
    );
  }
}
