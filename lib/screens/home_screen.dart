import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plakard/components/drawer.dart';
import 'package:plakard/components/topic_container.dart';
import 'package:plakard/components/carousel_item.dart';
import 'package:plakard/components/profile_pic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Builder(
                        builder: (context) {
                          return IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          'lib/assets/images/logo.png',
                          height: 90,
                        ),
                      ),
                    ),
                    const ProfilePic(
                      imagePath: 'lib/assets/images/profile.jpeg',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Hi, Sen!",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "MOST POPULAR",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('categories').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasData) {
                      var categories = snapshot.data!.docs;

                      var carouselCategories = categories.where((category) {
                        var data = category.data() as Map<String, dynamic>;
                        String name = data['name'] ?? 'Unknown';
                        return name == 'MATHEMATICS' ||
                            name == 'COMPUTER SCIENCE' ||
                            name == 'SCIENCE';
                      }).toList();

                      var exploreMoreCategories = categories.where((category) {
                        var data = category.data() as Map<String, dynamic>;
                        String name = data['name'] ?? 'Unknown';
                        return name != 'MATHEMATICS' &&
                            name != 'COMPUTER SCIENCE' &&
                            name != 'SCIENCE';
                      }).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: true,
                              height: 380,
                            ),
                            items: carouselCategories.map((category) {
                              var data =
                                  category.data() as Map<String, dynamic>;

                              int numOfTopics = data['topics'] is String
                                  ? int.tryParse(data['topics']) ?? 0
                                  : (data['topics'] ?? 0);

                              String logo = data['logo'] ??
                                  'lib/assets/images/default.png';
                              String name = data['name'] ?? 'Unknown Category';

                              return CarouselItem(
                                imagePath: logo,
                                mainHeading: name,
                                numOfCards: numOfTopics,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "EXPLORE MORE",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: exploreMoreCategories.map((category) {
                              var data =
                                  category.data() as Map<String, dynamic>;

                              int numOfTopics = data['topics'] is String
                                  ? int.tryParse(data['topics']) ?? 0
                                  : (data['topics'] ?? 0);

                              String name = (data['name'] ?? 'Unknown Category')
                                  .toString();

                              String logo = data['logo'] ??
                                  'lib/assets/images/default.png';

                              String subLine = "Learn the essentials of $name";

                              return Column(
                                children: [
                                  TopicContainer(
                                    imagePath: logo,
                                    mainHeading: name,
                                    subLine: subLine,
                                    numOfCards: numOfTopics,
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }
                    return const Text("No categories available");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
