import 'package:flutter/material.dart';
import 'package:livingdex_tracker/screens/dex_screen.dart';
import 'package:livingdex_tracker/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LivingDex Tracker',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255,222, 50, 64),
        shadowColor: const Color.fromARGB(255, 153, 35, 45),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 60.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pokemon',
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          titleSmall: TextStyle(
            fontSize: 100.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pokemon',
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          bodySmall: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pokemon',
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/dex': (context) => const DexScreen(generation: 1,),
      },
    );
  }
}


