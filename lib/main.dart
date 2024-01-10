import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'country_controller.dart';
import 'country_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing app');
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
  late Future<List<Country>> countriesFuture;
  late Map<String, String> selectedCountryDetails;

  final CountryController _countryController = CountryController();

  @override
  void initState() {
    super.initState();
    countriesFuture = _countryController.getCountries();
    selectedCountryDetails = {};
    updateCountryDetails(selectedCountry);
  }

  Future<void> updateCountryDetails(String countryCode) async {
    print('Updating country details for $countryCode');

    Country? selectedCountry =
        await _countryController.getCountryDetails(countryCode);

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
