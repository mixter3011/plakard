import 'package:flutter/material.dart';
import 'package:plakard/components/topic_container.dart';
import 'package:plakard/components/profile_pic.dart';
import 'package:plakard/components/drawer.dart';

class CardSelection extends StatefulWidget {
  final String title;
  final String topic;

  const CardSelection({
    super.key,
    required this.title,
    required this.topic,
  });

  @override
  State<CardSelection> createState() => _CardSelectionState();
}

class _CardSelectionState extends State<CardSelection> {
  List<TopicData> getTopicsForSelected() {
    switch (widget.topic) {
      case 'MATHEMATICS':
        return [
          TopicData('lib/assets/images/algebra.png', 'ALGEBRA',
              'Essential DBMS Questions!', 24),
          TopicData('lib/assets/images/calculus.png', 'CALCULUS',
              'Important Networking Concepts!', 15),
          TopicData('lib/assets/images/geometry.png', 'GEOMETRY',
              'Key OOP Questions!', 18),
          TopicData('lib/assets/images/stats.png', 'STATS & PROBABILITY',
              'Key OOP Questions!', 18),
          TopicData('lib/assets/images/set.png', 'SET THEORY',
              'Key OOP Questions!', 18),
          TopicData('lib/assets/images/complex.png', 'COMPLEX NUMBERS',
              'Key OOP Questions!', 18),
          TopicData('lib/assets/images/matalg.png', 'MATRIX ALGEBRA',
              'Key OOP Questions!', 18),
          TopicData('lib/assets/images/trigo.png', 'TRIGNOMETRY',
              'Key OOP Questions!', 18),
        ];
      case 'SCIENCE':
        return [
          TopicData('lib/assets/images/biology.png', 'BIOLOGY',
              'Essential DBMS Questions!', 24),
          TopicData('lib/assets/images/physics.png', 'PHYSICS',
              'Important Networking Concepts!', 15),
          TopicData('lib/assets/images/chemistry.png', 'CHEMISTRY',
              'Key OOP Questions!', 18)
        ];

      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final topics = getTopicsForSelected();

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const MyDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: ProfilePic(imagePath: 'lib/assets/images/profile.jpeg'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: topics.map((topic) {
              return Column(
                children: [
                  TopicContainer(
                    imagePath: topic.imagePath,
                    mainHeading: topic.mainHeading,
                    subLine: topic.subLine,
                    numOfCards: topic.numOfCards,
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class TopicData {
  final String imagePath;
  final String mainHeading;
  final String subLine;
  final int numOfCards;

  TopicData(this.imagePath, this.mainHeading, this.subLine, this.numOfCards);
}
