import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';

void main() {
  runApp(const MyApp());
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
        body: const Center(
          child: CountryDropdown(),
        ),
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
  static const List<String> countryList = <String>[
    'US', 'CA', 'GB', 'FR', 'DE',
    'IN', // Add more country codes as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image.asset(
        //   'assets/flags/$selectedCountry.png', // Replace with the path to your flag images
        //   height: 50,
        //   width: 50,
        // ),
        const SizedBox(height: 20),
        DropdownButton<String>(
          value: selectedCountry,
          onChanged: (String? value) {
            if (value != null) {
              setState(() {
                selectedCountry = value;
              });
            }
          },
          isExpanded: true,
          items: countryList.map<DropdownMenuItem<String>>(
            (String countryCode) {
              return DropdownMenuItem<String>(
                alignment: Alignment.center,
                value: countryCode,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CountryFlag.fromCountryCode(
                      countryCode,
                      height: 30,
                      width: 40,
                      borderRadius: 8,
                    ),
                    const SizedBox(width: 10),
                    Text(countryCode),
                  ],
                ),
              );
            },
          ).toList(),
        ),
        const SizedBox(height: 20),
        Text('Selected Country: $selectedCountry'),
      ],
    );
  }
}
