import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:meta_earth_single_mode/bottom_navigation_bar.dart';
import 'package:meta_earth_single_mode/country_controller.dart';
import 'package:meta_earth_single_mode/model/country_model.dart';
import 'package:meta_earth_single_mode/data/maps/world_map.dart';
import 'package:meta_earth_single_mode/model/country_relation_model.dart';
import 'package:meta_earth_single_mode/reset_controller.dart';
import 'package:provider/provider.dart';

class CountryColorsNotifier extends ChangeNotifier {
  final countryColorsNotifier = ValueNotifier<Map<String, Color>>({});

  void updateCountryColors(Map<String, Color> countryColors) =>
      countryColorsNotifier.value = countryColors;

  @override
  void dispose() {
    countryColorsNotifier.dispose();
    super.dispose();
  }
}

class WorldMapPage extends StatefulWidget {
  final String selectedCountry;

  const WorldMapPage({super.key, required this.selectedCountry});

  @override
  _WorldMapPageState createState() => _WorldMapPageState();
}

class _WorldMapPageState extends State<WorldMapPage> {
  final countryController = CountryController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late Box<int> _gameTurnBox;
  int gameTurn = 1;

  Future<void> _initHive() async {
    await Hive.initFlutter();
    _gameTurnBox = await Hive.openBox<int>('gameTurn');
    setState(() {
      gameTurn = _gameTurnBox.get('turn', defaultValue: 1)!;
    });
  }

  @override
  void initState() {
    super.initState();
    _initHive();
    countryController.getCountries().then((countries) {
      Provider.of<CountryProvider>(context, listen: false)
          .getCountryColors(countries, widget.selectedCountry)
          .then((countryColors) {
        Provider.of<CountryColorsNotifier>(context, listen: false)
            .updateCountryColors(countryColors);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Country>>(
      future: countryController.getCountries(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Consumer<CountryColorsNotifier>(
            builder: (context, countryColorsNotifier, child) {
              return ValueListenableBuilder<Map<String, Color>>(
                valueListenable: countryColorsNotifier.countryColorsNotifier,
                builder: (context, countryColors, child) {
                  print('Colors passed to SimpleMap: $countryColors');
                  if (countryColors.isEmpty) {
                    return const CircularProgressIndicator();
                  } else {
                    return Scaffold(
                      key: _scaffoldKey,
                      appBar: AppBar(
                        title: const Text('World Map'),
                        actions: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.settings_backup_restore),
                            onPressed: () =>
                                ResetController().showResetDialog(context),
                          ),
                        ],
                      ),
                      body: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Turn $gameTurn',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: InteractiveViewer(
                                    boundaryMargin: const EdgeInsets.all(20.0),
                                    minScale: 0.1,
                                    maxScale: 10.0,
                                    child: SimpleMap(
                                      instructions: SMapWorld.instructions,
                                      defaultColor: Colors.grey,
                                      countryBorder: const CountryBorder(
                                          color: Colors.black, width: .5),
                                      colors: countryColors,
                                      callback: (id, name, tapDetails) async {
                                        final country = await countryController
                                            .getCountryDetails(
                                                id.toUpperCase());
                                        if (country != null) {
                                          final countryName = country.name;
                                          _showDialog(country, snapshot.data!);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      bottomNavigationBar:
                          BottomNavBar(selectedCountry: widget.selectedCountry),
                    );
                  }
                },
              );
            },
          );
        }
      },
    );
  }

  void _showDialog(Country country, List<Country> countries) {
    final countryName = country.name;
    print('Show dialog called with country: $countryName');
    showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return FutureBuilder<int?>(
          future: CountryRelation.getRelationshipByCountryCode(country.code),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              print('Error fetching CountryRelation: ${snapshot.error}');
              return Text('Error: ${snapshot.error}');
            } else {
              final relationship = snapshot.data ?? 0;
              print('Fetched CountryRelation with relationship: $relationship');
              return AlertDialog(
                title: Text('Choose an action for $countryName'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      if (relationship == -1)
                        GestureDetector(
                          child: const Text("Attack"),
                          onTap: () {
                            // Add code here to handle the attack
                          },
                        ),
                      if (relationship != -1)
                        GestureDetector(
                          child: const Text("Declare War"),
                          onTap: () {
                            final countryColorsNotifier =
                                Provider.of<CountryColorsNotifier>(context,
                                    listen: false);
                            Provider.of<CountryProvider>(context, listen: false)
                                .declareWar(countryColorsNotifier, countries,
                                    widget.selectedCountry, country.code);

                            Navigator.pop(context);
                            setState(() {});
                          },
                        ),
                      // Add more actions here
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}

class CountryProvider extends ChangeNotifier {
  final countryColors = <String, Color>{};

  void updateCountryColor(String countryCode, Color color) {
    countryColors[countryCode] = color;
    print('Updated countryColors: $countryColors');
    notifyListeners();
  }

  Future<void> declareWar(
      CountryColorsNotifier countryColorsNotifier,
      List<Country> countries,
      String selectedCountry,
      String countryCode) async {
    var existingRelation = await CountryRelation.getRelation(countryCode);
    if (existingRelation != null) {
      existingRelation.relationship = -1; // Enemy
      await CountryRelation.updateRelation(countryCode, existingRelation);
    } else {
      final newRelation = CountryRelation(
        countryCode: countryCode,
        relationship: -1, // Enemy
      );
      await CountryRelation.addRelation(newRelation);
    }
    updateCountryColor(countryCode, Colors.red);

    final countryColors = await getCountryColors(countries, selectedCountry);
    countryColorsNotifier.updateCountryColors(countryColors);
  }

  Future<Map<String, Color>> getCountryColors(
      List<Country> countries, String selectedCountry) async {
    final countryColors = <String, Color>{};
    for (final country in countries) {
      final relationship =
          await CountryRelation.getRelationshipByCountryCode(country.code);
      print(relationship);
      countryColors[country.code.toLowerCase()] =
          relationship != null && relationship == -1
              ? Colors.red
              : Colors.yellow;
    }
    countryColors[selectedCountry.toLowerCase()] = Colors.green;
    return countryColors;
  }
}
