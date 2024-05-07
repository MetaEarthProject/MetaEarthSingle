import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meta_earth_single_mode/overview.dart';
import 'package:meta_earth_single_mode/economy_page.dart';

class BottomNavBar extends StatelessWidget {
  final String selectedCountry;

  const BottomNavBar({super.key, required this.selectedCountry});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                          builder: (context) =>
                              OverviewPage(selectedCountry: selectedCountry)),
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
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EconomyPage(selectedCountry: selectedCountry)),
                    );
                  },
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
    );
  }
}
