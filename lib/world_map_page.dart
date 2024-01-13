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
      bottomNavigationBar: Container(
        height: 100.0, // Specify your desired height
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.account_balance_outlined),
                    iconSize: 40.0,
                    onPressed: () {},
                  ),
                  Text('POLITICS'),
                ],
              ),
              VerticalDivider(color: Colors.black, thickness: 1.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.paid_outlined),
                    iconSize: 40.0,
                    onPressed: () {},
                  ),
                  Text('ECONOMY'),
                ],
              ),
              VerticalDivider(color: Colors.black, thickness: 1.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Image.asset('assets/tank400.png',
                        width: 40.0, height: 40.0),
                    iconSize: 40.0,
                    onPressed: () {},
                  ),
                  Text('MILLITARY'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
