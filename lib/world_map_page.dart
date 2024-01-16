import 'package:flutter/material.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:meta_earth_single_mode/bottom_navigation_bar.dart';
import 'package:meta_earth_single_mode/country_controller.dart';
import 'package:meta_earth_single_mode/model/country_model.dart';
import 'package:meta_earth_single_mode/data/maps/world_map.dart';
import 'package:meta_earth_single_mode/model/country_relation_model.dart';
import 'package:meta_earth_single_mode/reset_controller.dart';

class WorldMapPage extends StatefulWidget {
  final String selectedCountry;

  const WorldMapPage({super.key, required this.selectedCountry});

  @override
  _WorldMapPageState createState() => _WorldMapPageState();
}

class _WorldMapPageState extends State<WorldMapPage> {
  final countryController = CountryController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Country>>(
      future: CountryController().getCountries(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, Color> countryColors = {
            for (var country in snapshot.data!)
              country.code.toLowerCase(): Colors.yellow
          };
          countryColors[widget.selectedCountry.toLowerCase()] = Colors.green;

          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: const Text('World Map'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.settings_backup_restore),
                  onPressed: () => ResetController().showResetDialog(context),
                ),
              ],
            ),
            body: Stack(
              children: [
                // ignore: sized_box_for_whitespace
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: InteractiveViewer(
                    boundaryMargin: const EdgeInsets.all(20.0),
                    minScale: 0.1,
                    maxScale: 10.0,
                    child: SimpleMap(
                      instructions: SMapWorld.instructions,
                      defaultColor: Colors.grey,
                      countryBorder:
                          const CountryBorder(color: Colors.black, width: .5),
                      colors: countryColors,
                      callback: (id, name, tapDetails) async {
                        Country? country = await CountryController()
                            .getCountryDetails(id.toUpperCase());
                        if (country != null) {
                          String countryName = country.name;
                          print(countryName);
                          _showDialog(countryName);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar:
                BottomNavBar(selectedCountry: widget.selectedCountry),
          );
        }
      },
    );
  }

  void _showDialog(String countryName) {
    print('Show dialog called with country: $countryName'); // Add this line
    showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return FutureBuilder<CountryRelation?>(
          future: CountryRelation.getRelationByCountryCode(countryName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              print(
                  'Error fetching CountryRelation: ${snapshot.error}'); // Add this line
              return Text('Error: ${snapshot.error}');
            } else {
              int relationship = snapshot.data?.relationship ?? 0;
              print(
                  'Fetched CountryRelation with relationship: $relationship'); // Add this line
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
                          onTap: () async {
                            CountryRelation relation = CountryRelation(
                              id: 0, // You might want to generate a unique ID here
                              countryCode: countryName,
                              relationship: -1, // Enemy
                            );
                            await CountryRelation.addRelation(relation);
                            // You might want to check the relationship status here
                            // And add the action to a queue if the relationship is 'enemy'
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
