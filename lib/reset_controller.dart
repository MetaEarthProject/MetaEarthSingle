// reset_controller.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '/model/country_model.dart';
import '/model/defense.dart';
import '/model/user_model.dart';
import 'country_controller.dart';
import 'main.dart';

class ResetController {
  static final ResetController _instance = ResetController._internal();

  factory ResetController() => _instance;

  ResetController._internal();

  Future<void> resetGame() async {
    try {
      await Future.wait([
        Hive.box<Country>('countries').clear(),
        Hive.box<Military>('military').clear(),
        Hive.box<User>('users').clear(),
      ]);

      await CountryController().initDatabase();
    } catch (e) {
      print('Error resetting game: $e');
    }
  }

  Future<void> showResetDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Game'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to reset the game?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Reset'),
              onPressed: () {
                resetGame().then((_) {
                  // Use a separate BuildContext that is still valid after the async gap
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                    );
                  });
                });
              },
            ),
          ],
        );
      },
    );
  }
}
