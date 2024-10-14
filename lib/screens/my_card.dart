import 'dart:math';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plakard/components/drawer.dart';
import 'package:plakard/components/profile_pic.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MyCard extends StatefulWidget {
  const MyCard({super.key});

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  final TextEditingController _topicController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEnvVariables();
  }

  Future<void> _loadEnvVariables() async {
    await dotenv.load();
    OpenAI.apiKey = dotenv.env['OPENAI_API_KEY']!;
  }

  Future<void> _generateFlashCards(String topic) async {
    const promptTemplate =
        "Generate 20-30 college-level flashcards for the following topic. Format each flashcard as 'Q: [question] A: [answer]': ";
    final fullPrompt = "$promptTemplate$topic";

    try {
      final chatCompletion = await OpenAI.instance.chat.create(
        model: 'gpt-3.5-turbo',
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: fullPrompt,
            role: OpenAIChatMessageRole.user,
          ),
        ],
      );

      if (chatCompletion.choices.isNotEmpty) {
        String generatedText = chatCompletion.choices.first.message.content;
        print("Raw API response:\n$generatedText");

        List<Map<String, String>> questionsAndAnswers =
            _parseFlashcards(generatedText);

        print("Parsed ${questionsAndAnswers.length} flashcards");

        if (questionsAndAnswers.isNotEmpty) {
          try {
            await _saveToFirestore(topic, questionsAndAnswers);
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.success(
                message:
                    'Flash Cards have been created and saved! Check out in the Flashcards section',
              ),
            );
          } catch (e) {
            print("Error saving to Firestore: $e");
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: 'Error saving Flash Cards to database: $e',
              ),
            );
          }
        } else {
          print("No flashcards were parsed from the API response.");
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message:
                  'Error: No flashcards could be parsed from the API response',
            ),
          );
        }
      } else {
        print("No content generated from the API.");
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: 'Error: No content generated',
          ),
        );
      }
    } catch (e) {
      print("Error in _generateFlashCards: $e");
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: 'Error generating Flash Cards: $e',
        ),
      );
    }
  }

  List<Map<String, String>> _parseFlashcards(String text) {
    final List<Map<String, String>> flashcards = [];
    final RegExp questionAnswerPattern =
        RegExp(r'Q:\s*(.*?)\s*A:\s*(.*)', multiLine: true);

    final matches = questionAnswerPattern.allMatches(text);
    for (var match in matches) {
      String question = match.group(1) ?? 'No question found';
      String answer = match.group(2) ?? 'No answer found';
      flashcards.add({"question": question, "answer": answer});
    }

    return flashcards;
  }

  Future<void> _saveToFirestore(
      String topic, List<Map<String, String>> flashcards) async {
    final firestore = FirebaseFirestore.instance;

    final flashcardsCollectionRef = firestore.collection('flashcards');

    final topicDocRef = flashcardsCollectionRef.doc(topic);

    final Map<String, dynamic> topicData = {
      'createdAt': FieldValue.serverTimestamp(),
      'cards': flashcards,
    };

    await topicDocRef.set(topicData);

    print("Flashcards saved to Firestore under topic: $topic");
  }

  void _showModalDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Create Flash Card",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter the topic for your flash card:",
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _topicController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "e.g. Biology, History",
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String topic = _topicController.text;
                _generateFlashCards(topic);
                Navigator.of(context).pop();
              },
              child: const Text(
                "Create",
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CREATE CARDS",
          style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontWeight: FontWeight.w800),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: ProfilePic(
              imagePath: 'lib/assets/images/profile.jpeg',
            ),
          ),
        ],
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 220),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 350,
                height: 450,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomPaint(
                  painter: DashedBorderPainter(),
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 125),
                    child: Center(
                      child: Text(
                        "Create your own Flash Card",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                child: FloatingActionButton(
                  hoverColor: Colors.white,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  focusColor: Colors.white,
                  onPressed: _showModalDialog,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    _drawDashedLine(canvas, paint, const Offset(0, 0), Offset(size.width, 0));
    _drawDashedLine(
        canvas, paint, Offset(size.width, 0), Offset(size.width, size.height));
    _drawDashedLine(
        canvas, paint, Offset(size.width, size.height), Offset(0, size.height));
    _drawDashedLine(canvas, paint, Offset(0, size.height), const Offset(0, 0));
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset start, Offset end) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = sqrt(dx * dx + dy * dy);
    const dashWidth = 10.0;
    const dashSpace = 5.0;
    final dashCount = (distance / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final dashOffset = i * (dashWidth + dashSpace);
      final x = start.dx + (dx * (dashOffset / distance));
      final y = start.dy + (dy * (dashOffset / distance));
      canvas.drawLine(
        Offset(x, y),
        Offset(
            x + dx * (dashWidth / distance), y + dy * (dashWidth / distance)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
