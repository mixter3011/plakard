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
  int currentIndex = 0; // Track the current card being shown

  @override
  void initState() {
    super.initState();
    fetchCards();
  }

  Future<void> fetchCards() async {
    try {
      String formattedTopicName = widget.topicName.toLowerCase();

      CollectionReference cardsRef = FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryName)
          .collection('topics')
          .doc(formattedTopicName)
          .collection('cards');

      QuerySnapshot querySnapshot = await cardsRef.get();

      if (querySnapshot.docs.isEmpty) {
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

  void goToNextCard() {
    if (currentIndex < cardsData.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      // All cards are finished, show the end message
      setState(() {
        currentIndex = -1; // Use -1 to indicate the end of the cards
      });
    }
  }

  void restartFlashcards() {
    setState(() {
      currentIndex = 0; // Restart from the first card
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Ensure black background
      body: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : currentIndex == -1 // If all cards are done, show the end screen
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Flashcards have ended but not the revision!',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: restartFlashcards,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.all(
                                  20), // Button background color
                            ),
                            child: const Icon(
                              Icons.replay, // Retry symbol
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.9, // Adjust width
                        height: MediaQuery.of(context).size.height *
                            0.65, // Adjust height
                        child: CustomCard(
                          question: cardsData[currentIndex]['question'] ??
                              'No question',
                          answer:
                              cardsData[currentIndex]['answer'] ?? 'No answer',
                          onCardFlipped:
                              goToNextCard, // Move to next card after delay
                        ),
                      ),
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
