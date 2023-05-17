import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Function()? onTap;

  const LoginButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 100),
        decoration: BoxDecoration(
            color: const Color(0xFF6FA8DC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white24)),
        child: const Center(
            child: Text(
          "Sign In",
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              fontSize: 18),
        )),
      ),
    );
  }
}
