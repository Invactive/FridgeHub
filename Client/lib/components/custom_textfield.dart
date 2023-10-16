import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final TextInputType? keyboardType;
  final Icon? prefixIcon;
  static const double padding = 40.0;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.autocorrect,
      required this.enableSuggestions,
      required this.keyboardType,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    TextInputType? keyboardType;
    List<String>? autofillHints;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: padding),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        autofillHints: autofillHints,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          fillColor: Colors.grey[50],
          filled: true,
          hintText: hintText,
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
