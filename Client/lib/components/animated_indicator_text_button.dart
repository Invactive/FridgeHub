import 'package:flutter/material.dart';
// Addons Packages
import 'package:bouncing_widget/bouncing_widget.dart';

class AnimatedIndicatorTextButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;

  const AnimatedIndicatorTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<AnimatedIndicatorTextButton> createState() =>
      _AnimatedIndicatorTextButtonState();
}

class _AnimatedIndicatorTextButtonState
    extends State<AnimatedIndicatorTextButton> {
  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      duration: const Duration(milliseconds: 100),
      scaleFactor: 1.5,
      onPressed: () => widget.onPressed(),
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 100),
        decoration: BoxDecoration(
          color: const Color(0xFF6FA8DC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2.0,
                      ))
                  : Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
