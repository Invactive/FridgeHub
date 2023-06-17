// Amplify Flutter Packages
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:fridge_hub/pages/home_page.dart';
import 'package:fridge_hub/pages/login_page.dart';
import 'package:fridge_hub/pages/new_password_page.dart';

// Generated in previous step
import '../amplifyconfiguration.dart';
import 'package:flutter/material.dart';
import 'package:fridge_hub/components/animated_text_button.dart';
import 'package:fridge_hub/components/custom_textfield.dart';
import 'package:fridge_hub/components/animated_image_button.dart';
import 'package:fridge_hub/pages/forgot_password_code_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:page_transition/page_transition.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:async';

class ForgotPasswordEntryPage extends StatefulWidget {
  const ForgotPasswordEntryPage({super.key});

  @override
  State<ForgotPasswordEntryPage> createState() =>
      _ForgotPasswordEntryPageState();
}

class _ForgotPasswordEntryPageState extends State<ForgotPasswordEntryPage> {
  @override
  initState() {
    super.initState();
  }

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  final emailController = TextEditingController();

  bool validateEmail(TextEditingController email) {
    final bool isValid = EmailValidator.validate(email.text.trim());
    if (isValid) {
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Enter a valid E-Mail",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[400],
          textColor: Colors.black,
          fontSize: 16.0);
    }
    return false;
  }

  Future<void> resetPassword(String username) async {
    try {
      final result = await Amplify.Auth.resetPassword(
        username: username,
      );
      await _handleResetPasswordResult(result);
    } on AuthException catch (e) {
      safePrint('Error resetting password: ${e.message}');
      String message = e.message.endsWith('.')
          ? e.message.substring(0, e.message.length - 1)
          : e.message;
      Fluttertoast.showToast(
          msg: message.contains('Username/client id combination not found')
              ? 'E-Mail address not found'
              : message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[400],
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  Future<void> _handleResetPasswordResult(ResetPasswordResult result) async {
    switch (result.nextStep.updateStep) {
      case AuthResetPasswordStep.confirmResetPasswordWithCode:
        final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
        _handleCodeDelivery(codeDeliveryDetails);
        break;
      case AuthResetPasswordStep.done:
        safePrint('Successfully reset password');
        break;
    }
  }

  void _handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
    safePrint(
      'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
      'Please check your ${codeDeliveryDetails.deliveryMedium.name} for the code.',
    );
    Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: NewPasswordPage(email: emailController.text),
          duration: const Duration(milliseconds: 400),
        ));
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
              // email textfield
              CustomTextField(
                controller: emailController,
                hintText: 'E-Mail',
                obscureText: false,
                padding: 40.0,
                prefixIcon: const Icon(Icons.email),
              ),
              const SizedBox(
                height: 15,
              ),
              // confirm button
              AnimatedTextButton(
                text: "Confirm",
                // TODO resend password
                onPressed: () => validateEmail(emailController)
                    ? resetPassword(emailController.text)
                    : null,
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
