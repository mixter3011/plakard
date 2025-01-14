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
  int currentIndex = 0;
  bool isShowingAnswer = false;

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
      setState(() {
        isLoading = false;
      });
    }
  }

  void flipCard() {
    setState(() {
      isShowingAnswer = true;
    });

    Future.delayed(const Duration(seconds: 10), () {
      goToNextCard();
    });
  }

  void goToNextCard() {
    if (currentIndex < cardsData.length - 1) {
      setState(() {
        currentIndex++;
        isShowingAnswer = false;
      });
    } else {
      setState(() {
        currentIndex = -1;
        isShowingAnswer = false;
      });
    }
  }

  void restartFlashcards() {
    setState(() {
      currentIndex = 0;
      isShowingAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : currentIndex == -1
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
                              padding: const EdgeInsets.all(20),
                            ),
                            child: const Icon(
                              Icons.replay,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: CustomCard(
                          question: cardsData[currentIndex]['question'] ??
                              'No question',
                          answer:
                              cardsData[currentIndex]['answer'] ?? 'No answer',
                          onCardFlipped: flipCard,
                          isShowingAnswer: isShowingAnswer,
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
