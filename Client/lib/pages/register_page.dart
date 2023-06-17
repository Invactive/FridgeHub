// Amplify Flutter Packages
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:fridge_hub/pages/register_code_page.dart';

// Generated in previous step
import '../amplifyconfiguration.dart';
import 'package:flutter/material.dart';
import 'package:fridge_hub/components/animated_text_button.dart';
import 'package:fridge_hub/components/custom_textfield.dart';
import 'package:fridge_hub/components/custom_password_textfield.dart';
import 'package:fridge_hub/components/animated_image_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  initState() {
    super.initState();
  }

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signUp({
    required String username,
    required String password,
    required String email,
    String? phoneNumber,
  }) async {
    try {
      final userAttributes = {
        AuthUserAttributeKey.email: email,
        AuthUserAttributeKey.nickname: username,
        if (phoneNumber != null) AuthUserAttributeKey.phoneNumber: phoneNumber,
      };
      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: userAttributes,
        ),
      );
      await _handleSignUpResult(result);
    } on AuthException catch (e) {
      safePrint('Error signing up user: ${e.message}');
      String message = e.message.endsWith('.')
          ? e.message.substring(0, e.message.length - 1)
          : e.message;
      Fluttertoast.showToast(
          msg: username.isEmpty
              ? 'Please enter valid username'
              : (message.contains('Invalid email address format') ||
                          message.contains(
                              'Value at \'username\' failed to satisfy constraint')) &&
                      username.isNotEmpty
                  ? 'Please enter valid E-Mail'
                  : message.contains(
                          'Value at \'password\' failed to satisfy constraint')
                      ? 'Please enter valid password'
                      : message.contains('Password not long enough')
                          ? 'Password has to be at least 8 characters long'
                          : message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[400],
          textColor: Colors.black,
          fontSize: 16.0);
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
          child: RegisterCodePage(
            email: emailController.text,
          ),
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
              // welcome back text
              const Text("Create your profile to start!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(
                height: 40,
              ),
              // username textfield
              CustomTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
                padding: 40.0,
                prefixIcon: const Icon(Icons.person),
              ),
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
              // password textfield
              CustomPasswordTextField(
                controller: passwordController,
                hintText: 'Password',
                padding: 40.0,
                prefixIcon: const Icon(Icons.lock),
              ),
              const SizedBox(
                height: 15,
              ),
              // sign up button
              AnimatedTextButton(
                text: "Sign Up",
                onPressed: () => signUp(
                  username: usernameController.text,
                  email: emailController.text,
                  password: passwordController.text,
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
