import 'package:flutter/material.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:meta_earth_single_mode/bottom_navigation_bar.dart';
import 'package:meta_earth_single_mode/country_controller.dart';
import 'package:meta_earth_single_mode/model/country_model.dart';
import 'package:meta_earth_single_mode/data/maps/world_map.dart';

class WorldMapPage extends StatefulWidget {
  final String selectedCountry;

  const WorldMapPage({super.key, required this.selectedCountry});

  @override
  _WorldMapPageState createState() => _WorldMapPageState();
}

class _WorldMapPageState extends State<WorldMapPage> {
  final countryController = CountryController();

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
            appBar: AppBar(
              title: const Text('World Map'),
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
                      callback: (id, name, tapDetails) {
                        print(id);
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
}
