import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'database_helper.dart';
import 'country_model.dart';

void main() {
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
        body: const CountryDropdown(),
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
  late Future<List<Country>> countriesFuture; // Future to hold country objects
  late Map<String, String>
      selectedCountryDetails; // Map to hold country details

  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    // Initialize the database when the widget is created
    databaseHelper = DatabaseHelper();
    countriesFuture = initializeDatabase();
    selectedCountryDetails = {}; // Initialize an empty map
    updateCountryDetails(selectedCountry);
  }

  Future<List<Country>> initializeDatabase() async {
    // Fetch countries from the database
    List<Country> countries = await databaseHelper.getCountries();
    return countries;
  }

  Future<void> updateCountryDetails(String countryCode) async {
    Country? selectedCountry =
        await databaseHelper.getCountryDetails(countryCode);

    if (selectedCountry != null) {
      // When you call setState, Flutter schedules a rebuild of
      // the widget tree, and the build method is called again
      // to reflect the updated state.
      setState(() {
        selectedCountryDetails = {
          'Name': selectedCountry.name,
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
    return FutureBuilder(
      future: countriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Country>? countries = snapshot.data;

          if (countries == null || countries.isEmpty) {
            return const Center(
              child: Text('No countries available.'),
            );
          }

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
                    .map((entry) => Text('${entry.key}: ${entry.value}\n'))
                    .toList(),
              ),
            ],
          );
        } else {
          // Show loading indicator while initializing
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
