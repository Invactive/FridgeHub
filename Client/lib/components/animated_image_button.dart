import 'package:flutter/material.dart';
import 'package:bouncing_widget/bouncing_widget.dart';

class AnimatedImageButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String imagePath;

  const AnimatedImageButton({
    super.key,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
        duration: const Duration(milliseconds: 100),
        scaleFactor: 1.5,
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF6FA8DC),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: const EdgeInsets.all(8.0),
          height: 60,
          child: Image.asset(imagePath),
        ));
  }
}
