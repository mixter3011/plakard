import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  final String imagePath;

  const ProfilePic({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        imagePath,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
    );
  }
}
