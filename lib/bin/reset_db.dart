import 'package:flutter/widgets.dart';
import 'package:meta_earth_single_mode/country_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Resetting database');
  CountryController countryController = CountryController();
  await countryController.resetDatabase();
  print('Database reset complete.');
}
