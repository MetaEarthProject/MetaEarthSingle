import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '/model/country_model.dart';
import 'package:intl/intl.dart';

class EconomyPage extends StatefulWidget {
  final String selectedCountry;

  const EconomyPage({Key? key, required this.selectedCountry})
      : super(key: key);

  @override
  _EconomyPageState createState() => _EconomyPageState();
}

class _EconomyPageState extends State<EconomyPage> {
  late final Box<Country> countryBox;
  Country? country; // Nullable
  late double interestRate;
  double taxRate = 20.0;
  TextEditingController housesController = TextEditingController();
  TextEditingController factoriesController = TextEditingController();
  TextEditingController schoolsController = TextEditingController();
  int houses = 0;
  int factories = 0;
  int schools = 0;

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
      taxRate = 20.0; //country!.taxRate;
    } else {
      interestRate = 0.0; // Set a default value if country is null
      taxRate = 0.0;
    }
  }

  void adjustInterestRate(double adjustment) {
    setState(() {
      if (interestRate + adjustment >= 0) interestRate += adjustment;
    });
  }

  void adjustTaxRate(double adjustment) {
    setState(() {
      if (taxRate + adjustment >= 0) taxRate += adjustment;
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
                        DataCell(Text(NumberFormat('#,###')
                            .format(country?.stateBudget))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Unemployment Rate')),
                        DataCell(Text('${country?.unemploymentRate}%')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Population')),
                        DataCell(Text('${country?.population}')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Inflation Rate')),
                        DataCell(Text('${country?.inflationRate}%')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Interest Rate')),
                        DataCell(Text('${interestRate.toStringAsFixed(2)}%')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Tax Rate')),
                        DataCell(Text('${taxRate.toStringAsFixed(2)}%')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Houses')),
                        DataCell(
                          Row(
                            children: [
                              Text('$houses'),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    int quantity =
                                        int.tryParse(housesController.text) ??
                                            0;
                                    houses += quantity;
                                    housesController.clear();
                                    // Handle the quantity value as needed, for example, update a variable or perform an action
                                  });
                                },
                                child: Text('Build'),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: housesController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter quantity',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Factories')),
                        DataCell(
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: TextField(
                                  controller: factoriesController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter quantity',
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    int quantity = int.tryParse(
                                            factoriesController.text) ??
                                        0;
                                    factories += quantity;
                                    factoriesController.clear();
                                    // Handle the quantity value as needed, for example, update a variable or perform an action
                                  });
                                },
                                child: Text('Build'),
                              ),
                              const SizedBox(width: 8),
                              Text('Current: $factories'),
                            ],
                          ),
                        ),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Schools')),
                        DataCell(
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: TextField(
                                  controller: schoolsController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter quantity',
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    int quantity =
                                        int.tryParse(schoolsController.text) ??
                                            0;
                                    schools += quantity;
                                    schoolsController.clear();
                                    // Handle the quantity value as needed, for example, update a variable or perform an action
                                  });
                                },
                                child: Text('Build'),
                              ),
                              const SizedBox(width: 8),
                              Text('Current: $schools'),
                            ],
                          ),
                        ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          child: const Text('-0.25%'),
                          onPressed: () {
                            adjustTaxRate(-0.25);
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
                                  text: 'Current tax rate: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: taxRate.toStringAsFixed(2),
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
                            adjustTaxRate(0.25);
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
}
