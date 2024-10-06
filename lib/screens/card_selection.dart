import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<List<TopicData>> getTopicsForSelected() async {
    List<TopicData> topics = [];

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.topic)
          .collection('topics')
          .get();

      if (snapshot.docs.isEmpty) {
        print('No topics found in Firestore.');
      }

      for (var doc in snapshot.docs) {
        var data = doc.data();

        if (data.containsKey('logo') &&
            data.containsKey('subline') &&
            data.containsKey('number')) {
          topics.add(
            TopicData(
              data['logo'],
              doc.id.toUpperCase(),
              data['subline'],
              data['number'],
            ),
          );
        } else {
          print("Document missing some required fields: ${doc.id}");
        }
      }

      print("Total topics fetched: ${topics.length}");
    } catch (e) {
      print('Error fetching topics: $e');
    }

    return topics;
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<TopicData>>(
        future: getTopicsForSelected(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching topics'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No topics available'));
          }

          final topics = snapshot.data!;

          return Padding(
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
          );
        },
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
