import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plakard/components/drawer.dart';
import 'package:plakard/components/profile_pic.dart';
import 'package:plakard/components/user_topic_container.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<List<TopicData>> getTopicsForUser() async {
    List<TopicData> topics = [];

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('flashcards').get();

      if (snapshot.docs.isEmpty) {
        print('No flashcards found in Firestore.');
      }

      for (var doc in snapshot.docs) {
        var data = doc.data();
        int numOfCards = 0;

        if (data.containsKey('cards') && data['cards'] is List) {
          numOfCards = (data['cards'] as List).length;
        }

        topics.add(
          TopicData(
            'lib/assets/images/default.png',
            doc.id,
            'User Cards',
            numOfCards,
          ),
        );
      }

      print("Total flashcard topics fetched: ${topics.length}");
    } catch (e) {
      print('Error fetching flashcard topics: $e');
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
        title: const Text(
          "PROFILE",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: ProfilePic(imagePath: 'lib/assets/images/profile.jpeg'),
          ),
        ],
      ),
      body: FutureBuilder<List<TopicData>>(
        future: getTopicsForUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No flashcards available'));
          }

          final topics = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: topics.map((topic) {
                  return Column(
                    children: [
                      UserTopicContainer(
                        imagePath: topic.imagePath,
                        mainHeading: topic.mainHeading,
                        subLine: topic.subLine,
                        numOfCards: topic.numOfCards,
                        categoryName: 'USER',
                        topicName: topic.mainHeading,
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
