import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '/model/country_model.dart';

class EconomyPage extends StatefulWidget {
  final String selectedCountry;

  const EconomyPage({super.key, required this.selectedCountry});

  @override
  _EconomyPageState createState() => _EconomyPageState();
}

class _EconomyPageState extends State<EconomyPage> {
  late final Box<Country> countryBox;
  Country? country; // Nullable
  late double interestRate;

  @override
  void initState() {
    super.initState();
    countryBox = Hive.box<Country>('countries');
    _loadCountry();
  }

  void _loadCountry() {
    country = countryBox.get(widget.selectedCountry);
    if (country == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Country not found in the box'),
      ));
    }
    setState(() {}); // Trigger a rebuild
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (country != null) {
      interestRate = country!.interestRate;
    } else {
      interestRate = 0.0; // Set a default value if country is null
    }
  }

  void adjustInterestRate(double adjustment) {
    setState(() {
      if (interestRate + adjustment >= 0) interestRate += adjustment;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (country == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Economy')),
        body: const Center(child: Text('Error: Country is null')),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text('${country!.name} Economy')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Value')),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text('State Budget')),
                        DataCell(Text('${country?.stateBudget}')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Unemployment Rate')),
                        DataCell(Text('${country?.unemploymentRate}')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Population')),
                        DataCell(Text('${country?.population}')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Inflation Rate')),
                        DataCell(Text('${country?.inflationRate}')),
                      ]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          child: const Text('-0.25%'),
                          onPressed: () {
                            adjustInterestRate(-0.25);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.center,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Current interest rate: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: interestRate.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          child: const Text('+0.25%'),
                          onPressed: () {
                            adjustInterestRate(0.25);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget economyCard(String title, String data) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(data),
        trailing: ElevatedButton(
          child: const Text('Develop'),
          onPressed: () {
            // TODO: Implement development action
          },
        ),
      ),
    );
  }
}
