import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
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
                  "Hi,Sen!",
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
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    height: 380,
                  ),
                  items: const [
                    CarouselItem(
                      imagePath: 'lib/assets/images/maths.png',
                      mainHeading: 'MATHEMATICS',
                      numOfCards: 24,
                    ),
                    CarouselItem(
                      imagePath: 'lib/assets/images/science.png',
                      mainHeading: 'SCIENCE',
                      numOfCards: 15,
                    ),
                    CarouselItem(
                      imagePath: 'lib/assets/images/cs.png',
                      mainHeading: 'COMPUTER SCIENCE',
                      numOfCards: 18,
                    ),
                  ],
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
                const Column(
                  children: [
                    TopicContainer(
                      imagePath: 'lib/assets/images/dbms-white.png',
                      mainHeading: 'DBMS',
                      subLine: 'Essential DBMS Questions!',
                      numOfCards: 24,
                    ),
                    SizedBox(height: 10),
                    TopicContainer(
                      imagePath: 'lib/assets/images/Networks.png',
                      mainHeading: 'NETWORKS',
                      subLine: 'Important Networking Concepts!',
                      numOfCards: 15,
                    ),
                    SizedBox(height: 10),
                    TopicContainer(
                      imagePath:
                          'lib/assets/images/Object oriented programming.png',
                      mainHeading: 'OOP',
                      subLine: 'Key OOP Questions!',
                      numOfCards: 18,
                    ),
                    SizedBox(height: 10),
                    TopicContainer(
                      imagePath: 'lib/assets/images/Data structure diagram.png',
                      mainHeading: 'DATA STRUCTURES',
                      subLine: 'Essential DS Questions!',
                      numOfCards: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
