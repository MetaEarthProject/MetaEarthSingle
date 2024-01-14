import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:hive/hive.dart';
import 'country_model.dart';

class OverviewPage extends StatelessWidget {
  final String selectedCountry;

  const OverviewPage({Key? key, required this.selectedCountry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final countryBox = Hive.box<Country>('countries');
    final country = countryBox.get(selectedCountry);

    return Scaffold(
      appBar: AppBar(
        title: Text('Overview of ${country?.name ?? 'Unknown'}'),
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
                    'Government: ${country.governmentSystem}',
                  ),
                ),
              ],
            )
          : Center(
              child:
                  Text('No information available for the selected country.')),
    );
  }
}
