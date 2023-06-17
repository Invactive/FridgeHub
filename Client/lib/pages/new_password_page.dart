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
import 'package:fridge_hub/components/custom_password_textfield.dart';
import 'package:fridge_hub/components/animated_image_button.dart';
import 'package:fridge_hub/pages/forgot_password_code_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:page_transition/page_transition.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:async';

class NewPasswordPage extends StatefulWidget {
  final String email;

  const NewPasswordPage({super.key, required this.email});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  @override
  initState() {
    super.initState();
  }

  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  int _passwordLengthPolicy = 8; // Change if policy changes

  void checkPasswordsMatch({
    required String pass1,
    required String pass2,
  }) {
    if (pass1 == pass2) {
      if (pass1.length >= _passwordLengthPolicy) {
        Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: ForgotPasswordCodePage(
                email: widget.email,
                password: pass1,
              ),
              duration: const Duration(milliseconds: 400),
            ));
      } else {
        Fluttertoast.showToast(
            msg:
                "Password does not conform to policy: Password not long enough",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey[400],
            textColor: Colors.black,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Passwords do not match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[400],
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

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
              const Text("Change your password",
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
              const Text("Enter a new password below to change your password",
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
              // password textfield
              CustomPasswordTextField(
                controller: passwordController,
                hintText: 'New Password',
                padding: 40.0,
                prefixIcon: const Icon(Icons.lock),
              ),
              const SizedBox(
                height: 15,
              ),
              // confirm password textfield
              CustomPasswordTextField(
                controller: passwordConfirmController,
                hintText: 'Confirm New Password',
                padding: 40.0,
                prefixIcon: const Icon(Icons.lock),
              ),
              const SizedBox(
                height: 15,
              ),
              // confirm button
              AnimatedTextButton(
                text: "Confirm",
                // TODO confirm password
                onPressed: () => checkPasswordsMatch(
                  pass1: passwordController.text,
                  pass2: passwordConfirmController.text,
                ),
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
