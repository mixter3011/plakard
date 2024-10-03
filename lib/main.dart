import 'package:flutter/material.dart';
import 'package:plakard/screens/home_screen.dart';
import 'package:plakard/screens/card_selection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/cardSelection': (context) => const CardSelection(
              title: '',
              topic: '',
            ),
      },
    );
  }
}
