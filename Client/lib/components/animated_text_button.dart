import 'package:flutter/material.dart';
import 'package:bouncing_widget/bouncing_widget.dart';

class AnimatedTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const AnimatedTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
        duration: const Duration(milliseconds: 100),
        scaleFactor: 1.5,
        onPressed: onPressed,
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
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Center(
              child: Text(
            text,
            style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                fontSize: 18),
          )),
        ));
  }
}

// GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 300),
//         padding: const EdgeInsets.all(15),
//         margin: const EdgeInsets.symmetric(horizontal: 100),
//         decoration: BoxDecoration(
//           color: const Color(0xFF6FA8DC),
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.white24),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.7),
//               spreadRadius: 5,
//               blurRadius: 7,
//               offset: Offset(0, 3), // changes position of shadow
//             ),
//           ],
//         ),
//         child: const Center(
//             child: Text(
//           "Sign In",
//           style: TextStyle(
//               color: Colors.black,
//               fontFamily: 'Lato',
//               fontWeight: FontWeight.bold,
//               fontSize: 18),
//         )),
//       ),
//     );