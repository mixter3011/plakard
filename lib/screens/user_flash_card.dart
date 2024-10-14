import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plakard/components/mycard.dart';
import 'package:plakard/components/profile_pic.dart';

class UserFlashCard extends StatefulWidget {
  final String categoryName;
  final String topicName;

  const UserFlashCard({
    super.key,
    required this.categoryName,
    required this.topicName,
  });

  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<UserFlashCard> {
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
      DocumentReference cardsRef = FirebaseFirestore.instance
          .collection('flashcards')
          .doc(widget.topicName);

      DocumentSnapshot docSnapshot = await cardsRef.get();

      if (!docSnapshot.exists) {
        setState(() {
          isLoading = false;
          cardsData = [];
        });
        return;
      }

      List<dynamic> cardsList = docSnapshot.get('cards') ?? [];

      for (var card in cardsList) {
        cardsData.add({
          'question': card['question'] ?? 'No question',
          'answer': card['answer'] ?? 'No answer',
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching cards: $e");
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
                  : currentIndex >= 0 && currentIndex < cardsData.length
                      ? Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.65,
                            child: CustomCard(
                              question: cardsData[currentIndex]['question'] ??
                                  'No question',
                              answer: cardsData[currentIndex]['answer'] ??
                                  'No answer',
                              onCardFlipped: flipCard,
                              isShowingAnswer: isShowingAnswer,
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            'No flashcards available for this topic.',
                            style: TextStyle(color: Colors.white, fontSize: 20),
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
