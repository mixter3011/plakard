import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({super.key});

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 3.14).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateCard() {
    setState(() {
      _isTapped = !_isTapped;
      if (_isTapped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _animateCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.rotationY(_animation.value),
            alignment: Alignment.center,
            child: Container(
              width: 400,
              height: 600,
              decoration: BoxDecoration(
                color: _isTapped ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 3),
              ),
              alignment: Alignment.center,
              child: Text(
                'Simple Card',
                style: TextStyle(
                  color: _isTapped ? Colors.black : Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
