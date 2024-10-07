import 'package:flutter/material.dart';
import 'package:plakard/components/mycard.dart';

class FlashCard extends StatefulWidget {
  const FlashCard({super.key});

  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CustomCard(),
      ),
    );
  }
}
