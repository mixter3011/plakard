import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plakard/screens/home_screen.dart';
import 'package:plakard/screens/card_selection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
