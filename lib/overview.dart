import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '/model/country_model.dart';
import 'package:meta_earth_single_mode/model/defense.dart'; // Import the Military model

class OverviewPage extends StatelessWidget {
  final String selectedCountry;

  const OverviewPage({super.key, required this.selectedCountry});

  @override
  Widget build(BuildContext context) {
    final countryBox = Hive.box<Country>('countries');
    final country = countryBox.get(selectedCountry);

    final militaryBox = Hive.box<Military>('military'); // Open the military box
    final military =
        militaryBox.get(selectedCountry); // Get the Military object

    return Scaffold(
      appBar: AppBar(
        title: const Text('COUNTRY OVERVIEW'),
      ),
      body: country != null
          ? Column(
              children: [
                ListTile(
                  leading: CountryFlag.fromCountryCode(
                    country.code,
                    height: 30,
                    width: 40,
                  ),
                  title: Text(country.name),
                  subtitle: Text(
                    'Population: ${country.population}\n'
                    'GDP: ${country.gdp}\n'
                    'Government: ${country.governmentSystem}\n'
                    'Infantry: ${military != null ? NumberFormat.decimalPattern().format(military.infantry) : 'N/A'}\n'
                    'Tank: ${military != null ? NumberFormat.decimalPattern().format(military.tank) : 'N/A'}\n'
                    'Airforce: ${military != null ? NumberFormat.decimalPattern().format(military.airforce) : 'N/A'}',
                  ),
                ),
              ],
            )
          : const Center(
              child:
                  Text('No information available for the selected country.')),
    );
  }
}
