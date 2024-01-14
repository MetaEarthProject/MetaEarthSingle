import 'package:flutter/material.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:meta_earth_single_mode/country_controller.dart';
import 'package:meta_earth_single_mode/country_model.dart';
import 'package:meta_earth_single_mode/data/maps/world_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meta_earth_single_mode/overview.dart';

class WorldMapPage extends StatefulWidget {
  final String selectedCountry;

  const WorldMapPage({super.key, required this.selectedCountry});

  @override
  _WorldMapPageState createState() => _WorldMapPageState();
}

class _WorldMapPageState extends State<WorldMapPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Country>>(
      future: CountryController().getCountries(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
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
            bottomNavigationBar: SizedBox(
              height: 100.0,
              child: BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.globe),
                          iconSize: 30.0,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OverviewPage(
                                      selectedCountry: widget.selectedCountry)),
                            );
                          },
                        ),
                        const Text('OVERVIEW'),
                      ],
                    ),
                    const VerticalDivider(color: Colors.black, thickness: 1.0),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.account_balance_outlined),
                          iconSize: 30.0,
                          onPressed: () {},
                        ),
                        const Text('POLITICS'),
                      ],
                    ),
                    const VerticalDivider(color: Colors.black, thickness: 1.0),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.paid_outlined),
                          iconSize: 30.0,
                          onPressed: () {},
                        ),
                        const Text('ECONOMY'),
                      ],
                    ),
                    const VerticalDivider(color: Colors.black, thickness: 1.0),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Image.asset('assets/tank400.png',
                              width: 30.0, height: 30.0),
                          iconSize: 30.0,
                          onPressed: () {},
                        ),
                        const Text('MILLITARY'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
