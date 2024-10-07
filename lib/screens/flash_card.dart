import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plakard/components/mycard.dart';
import 'package:plakard/components/profile_pic.dart';

class FlashCard extends StatefulWidget {
  final String categoryName;
  final String topicName;

  const FlashCard({
    super.key,
    required this.categoryName,
    required this.topicName,
  });

  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  List<Map<String, String>> cardsData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCards();
  }

  Future<void> fetchCards() async {
    try {
      // Convert topicName to lowercase to match Firestore document IDs
      String formattedTopicName = widget.topicName.toLowerCase();

      CollectionReference cardsRef = FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryName)
          .collection('topics')
          .doc(formattedTopicName) // Use formatted topic name here
          .collection('cards');

      print('Fetching cards from: ${cardsRef.path}');

      QuerySnapshot querySnapshot = await cardsRef.get();

      if (querySnapshot.docs.isEmpty) {
        print('No cards found for the selected topic.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      List<Map<String, String>> fetchedCards = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return {
          'question': data['question'] as String? ?? 'No question',
          'answer': data['answer'] as String? ?? 'No answer',
        };
      }).toList();

      setState(() {
        cardsData = fetchedCards;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching cards: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : cardsData.isEmpty
                  ? const Center(
                      child: Text('No cards available',
                          style: TextStyle(color: Colors.white)))
                  : PageView.builder(
                      itemCount: cardsData.length,
                      itemBuilder: (context, index) {
                        final card = cardsData[index];
                        return CustomCard(
                          question: card['question'] ?? 'No question',
                          answer: card['answer'] ?? 'No answer',
                        );
                      },
                    ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                const ProfilePic(imagePath: 'lib/assets/images/profile.jpeg'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
