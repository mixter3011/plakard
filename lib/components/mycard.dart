import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final String question;
  final String answer;
  final VoidCallback onCardFlipped;
  final bool isShowingAnswer;

  const CustomCard({
    super.key,
    required this.question,
    required this.answer,
    required this.onCardFlipped,
    required this.isShowingAnswer,
  });

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void didUpdateWidget(CustomCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isShowingAnswer != oldWidget.isShowingAnswer) {
      if (widget.isShowingAnswer) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void flipCard() {
    if (!widget.isShowingAnswer) {
      widget.onCardFlipped();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: flipCard,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final isFlipped = _flipAnimation.value >= 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_flipAnimation.value * 3.14),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: isFlipped ? Colors.white : Colors.black,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isFlipped ? Colors.transparent : Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: isFlipped
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(3.14),
                        child: Text(
                          widget.answer,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 24, color: Colors.black),
                        ),
                      )
                    : Text(
                        widget.question,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
