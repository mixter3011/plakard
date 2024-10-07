import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final String question;
  final String answer;

  const CustomCard({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _flipped = false; // Track if the card is flipped

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  void flipCard() {
    if (_flipped) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _flipped = !_flipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(_animation.value * 3.14),
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: _flipped
                  ? Center(
                      child: Text(
                        widget.answer,
                        style: const TextStyle(fontSize: 24),
                      ),
                    )
                  : Center(
                      child: Text(
                        widget.question,
                        style: const TextStyle(fontSize: 24),
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
