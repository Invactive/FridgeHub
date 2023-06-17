// Amplify Flutter Packages
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:fridge_hub/pages/home_page.dart';
import 'package:fridge_hub/pages/login_page.dart';

// Generated in previous step
import '../amplifyconfiguration.dart';
import 'package:flutter/material.dart';
import 'package:fridge_hub/components/animated_text_button.dart';
import 'package:fridge_hub/components/custom_textfield.dart';
import 'package:fridge_hub/components/animated_image_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:async';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  initState() {
    super.initState();
  }

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  final emailController = TextEditingController();
  String code = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[200],
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey[200]!,
                Colors.grey[500]!,
              ],
            ),
          ),
          child: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // logo
              const Image(
                image: AssetImage("lib/assets/images/fridgehub_logo.png"),
                alignment: Alignment.topCenter,
              ),
              const SizedBox(
                height: 25,
              ),
              // forgot password text
              const Text("Forgot password?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(
                height: 5,
              ),
              const Text("Enter the email address associated with your account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w400,
                  )),
              const Text(
                  "We will send you a verification code to check your authenticity",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w400,
                  )),
              const SizedBox(
                height: 15,
              ),
              // code textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  cursorColor: Colors.blue,
                  hapticFeedbackTypes: HapticFeedbackTypes.heavy,
                  pinTheme: PinTheme(
                    activeColor: Colors.black,
                    selectedColor: Colors.blue,
                    inactiveColor: Colors.grey,
                  ),
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w700,
                  ),
                  keyboardType: TextInputType.number,
                  animationDuration: const Duration(milliseconds: 100),
                  errorAnimationController: errorController,
                  onChanged: (value) {
                    setState(() {
                      code = value;
                    });
                  },
                  appContext: context,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // resend code
              GestureDetector(
                // onTap: () => resendCode(email: widget.email),
                child: const Text("Resend code",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.w600,
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              // confirm button
              AnimatedTextButton(
                text: "Confirm",
                // TODO
                onPressed: () {
                  if (code.length != 6) {}
                  safePrint(code);
                },
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          )),
        ),
      ),
    );
  }
}
