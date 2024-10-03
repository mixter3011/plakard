import 'package:flutter/material.dart';
import 'package:plakard/components/topic_container.dart'; // Import TopicContainer
import 'package:plakard/components/profile_pic.dart'; // Import ProfilePic for the profile picture
import 'package:plakard/components/drawer.dart'; // Import MyDrawer for the menu

class CardSelection extends StatefulWidget {
  final String title; // Accept title from CarouselItem

  const CardSelection({super.key, required this.title});

  @override
  State<CardSelection> createState() => _CardSelectionState();
}

class _CardSelectionState extends State<CardSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const MyDrawer(), // Add the drawer from HomeScreen
      appBar: AppBar(
        backgroundColor: Colors.white, // Set the AppBar background color
        elevation: 0, // Remove the shadow below the AppBar
        title: Text(
          widget.title, // Display the title passed from CarouselItem
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black), // Menu icon
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0), // Add some padding
            child: ProfilePic(
                imagePath: 'lib/assets/images/profile.jpeg'), // Profile picture
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0), // Adding padding
        child: Column(
          children: [
            TopicContainer(
              imagePath: 'lib/assets/images/dbms-white.png',
              mainHeading: 'DBMS',
              subLine: 'Essential DBMS Questions!',
              numOfCards: 24,
            ),
            SizedBox(height: 10), // Spacing between containers
            TopicContainer(
              imagePath: 'lib/assets/images/Networks.png',
              mainHeading: 'NETWORKS',
              subLine: 'Important Networking Concepts!',
              numOfCards: 15,
            ),
            SizedBox(height: 10),
            TopicContainer(
              imagePath: 'lib/assets/images/Object oriented programming.png',
              mainHeading: 'OOP',
              subLine: 'Key OOP Questions!',
              numOfCards: 18,
            ),
          ],
        ),
      ),
    );
  }
}
