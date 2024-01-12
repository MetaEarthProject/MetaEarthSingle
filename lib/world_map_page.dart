import 'package:flutter/material.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:meta_earth_single_mode/data/maps/world_map.dart';

class WorldMapPage extends StatelessWidget {
  final String selectedCountry;

  const WorldMapPage({super.key, required this.selectedCountry});

  @override
  Widget build(BuildContext context) {
    Map<String, Color> countryColors = {
      selectedCountry.toLowerCase(): Colors.green
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('World Map'),
      ),
      body: Center(
        child: SimpleMap(
          instructions: SMapWorld.instructions,
          defaultColor: Colors.grey,
          colors: countryColors,
          callback: (id, name, tapDetails) {
            print(id);
          },
        ),
      ),
    );
  }
}
