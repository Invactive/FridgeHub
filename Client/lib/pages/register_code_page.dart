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
import 'package:flutter_verification_code/flutter_verification_code.dart';

class RegisterCodePage extends StatefulWidget {
  final String email;

  const RegisterCodePage({super.key, required this.email});

  @override
  State<RegisterCodePage> createState() => _RegisterCodePageState();
}

class _RegisterCodePageState extends State<RegisterCodePage> {
  @override
  initState() {
    super.initState();
  }

  late String? emailDestination;
  late String? deliveryMedium;
  final codeController = TextEditingController();

  Future<void> resendSignUpCode({
    required String email,
  }) async {
    try {
      final result = await Amplify.Auth.resendSignUpCode(username: email);
      safePrint("Code resent: $result");
      Fluttertoast.showToast(
          msg: "Confirmation code sent",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[400],
          textColor: Colors.black,
          fontSize: 16.0);
    } on AuthException catch (e) {
      safePrint('Error confirming user: ${e.message}');
    }
  }

  Future<void> confirmUser({
    required String email,
    required String confirmationCode,
  }) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: confirmationCode,
      );
      await _handleSignUpResult(result);
    } on AuthException catch (e) {
      safePrint('Error confirming user: ${e.message}');
    }
  }

  Future<void> _handleSignUpResult(SignUpResult result) async {
    switch (result.nextStep.signUpStep) {
      case AuthSignUpStep.confirmSignUp:
        final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
        _handleCodeDelivery(codeDeliveryDetails);
        break;
      case AuthSignUpStep.done:
        safePrint('Sign up is complete');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        Navigator.of(context).popUntil(ModalRoute.withName("/LoginPage"));
        break;
    }
  }

  void _handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
    emailDestination = codeDeliveryDetails.destination;
    deliveryMedium = codeDeliveryDetails.deliveryMedium.name;
    safePrint(
      'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
      'Please check your ${codeDeliveryDetails.deliveryMedium.name} for the code.',
    );
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
              // welcome back text
              const Text("Please enter a confirmation code",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(
                height: 5,
              ),
              const Text(
                  "A confirmation code has been sent to your E-Mail address",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w400,
                  )),
              const SizedBox(
                height: 25,
              ),
              // code textfield
              CustomTextField(
                controller: codeController,
                hintText: 'Code',
                obscureText: false,
                padding: 80.0,
              ),
              const SizedBox(
                height: 15,
              ),
              // resend code
              GestureDetector(
                onTap: () => resendSignUpCode(email: widget.email),
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
                onPressed: () => confirmUser(
                  email: widget.email,
                  confirmationCode: codeController.text,
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
