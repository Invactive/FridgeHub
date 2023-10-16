import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  const SquareTile({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF6FA8DC),
      ),
      padding: const EdgeInsets.all(8.0),
      height: 60,
      child: Image.asset(imagePath),
    );
  }
}
