import 'package:flutter/material.dart';
import 'package:livingdex_tracker/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LivingDex Tracker',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255,222, 50, 64),
      ),
      home: const HomeScreen(),
    );
  }
}


