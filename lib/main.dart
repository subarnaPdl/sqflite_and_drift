import 'package:flutter/material.dart';
import 'package:sqflite_and_drift/data_functions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dataFunctions();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sqflite and Drift',
      home: Scaffold(
        body: Container(),
      ),
    );
  }
}
