// Amplify Flutter Packages
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:fridge_hub/pages/register_code_page.dart';
import 'package:fridge_hub/pages/home_page.dart';
import 'package:fridge_hub/pages/register_page.dart';
import 'package:fridge_hub/pages/forgot_password_page.dart';

// Generated in previous step
import '../amplifyconfiguration.dart';
import 'package:flutter/material.dart';
import 'package:fridge_hub/components/animated_text_button.dart';
import 'package:fridge_hub/components/custom_textfield.dart';
import 'package:fridge_hub/components/custom_password_textfield.dart';
import 'package:fridge_hub/components/animated_image_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  initState() {
    super.initState();
    // _configureAmplify();
    signOutIn();
  }

  void signOutIn() async {
    await _configureAmplify();
    await signOutCurrentUser();
  }

  Future<void> _configureAmplify() async {
    try {
      final authPlugin = AmplifyAuthCognito();
      // TODO - AWS Analytics plugin
      // final analyticsPlugin = AmplifyAnalyticsPinpoint();
      await Amplify.addPlugins([authPlugin]);
      await Amplify.configure(amplifyconfig);
      safePrint('Successfully configured Amplify');
    } on Exception catch (e) {
      safePrint('Error configuring Amplify: $e');
    }
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signInUser(String username, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      await _handleSignInResult(result);
    } on AuthException catch (e) {
      safePrint('Error signing in: ${e.message}');
      String message = e.message.endsWith('.')
          ? e.message.substring(0, e.message.length - 1)
          : e.message;
      Fluttertoast.showToast(
          msg: message.contains('Missing required parameter USERNAME')
              ? 'Please enter an E-Mail address'
              : message.contains('User does not exist')
                  ? 'The user does not exist'
                  : message.contains('No password given')
                      ? 'Please enter a password'
                      : message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[400],
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  Future<void> signOutCurrentUser() async {
    final result = await Amplify.Auth.signOut();
    if (result is CognitoCompleteSignOut) {
      safePrint('Sign out completed successfully');
    } else if (result is CognitoFailedSignOut) {
      safePrint('Error signing user out: ${result.exception.message}');
    }
  }

  Future<void> _handleSignInResult(SignInResult result) async {
    switch (result.nextStep.signInStep) {
      case AuthSignInStep.confirmSignInWithSmsMfaCode:
        final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
        _handleCodeDelivery(codeDeliveryDetails);
        break;
      case AuthSignInStep.confirmSignInWithNewPassword:
        safePrint('Enter a new password to continue signing in');
        break;
      case AuthSignInStep.confirmSignInWithCustomChallenge:
        final parameters = result.nextStep.additionalInfo;
        final prompt = parameters['prompt']!;
        safePrint(prompt);
        break;
      case AuthSignInStep.resetPassword:
        final resetResult = await Amplify.Auth.resetPassword(
          username: emailController.text,
        );
        await _handleResetPasswordResult(resetResult);
        break;
      case AuthSignInStep.confirmSignUp:
        // Resend the sign up code to the registered device.
        final resendResult = await Amplify.Auth.resendSignUpCode(
          username: emailController.text,
        );
        _handleCodeDelivery(resendResult.codeDeliveryDetails);
        break;
      case AuthSignInStep.done:
        safePrint('Sign in is complete');
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: const HomePage(),
            duration: const Duration(milliseconds: 400),
          ),
          (route) => false,
        );
        break;
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
  }

  void resetPassword() {
    Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: const ForgotPasswordPage(),
          duration: const Duration(milliseconds: 400),
        ));
  }

  void registerNow() {
    Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: const RegisterPage(),
          duration: const Duration(milliseconds: 400),
        ));
  }

  void googleLogin() {
    // TODO AWS Google auth
    safePrint('Google login Clicked!');
  }

  void facebookLogin() {
    // TODO AWS Facebook auth
    safePrint('Facebook login Clicked!');
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
              const Text("Welcome back, you've been missed!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(
                height: 40,
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
              // forgot password
              GestureDetector(
                onTap: resetPassword,
                child: const Text("Forgot password?",
                    textAlign: TextAlign.center,
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
              // sign in button
              AnimatedTextButton(
                text: "Sign In",
                onPressed: () =>
                    signInUser(emailController.text, passwordController.text),
              ),
              const SizedBox(
                height: 15,
              ),
              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[800],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Or continue with",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[800],
                  ))
                ]),
              ),
              const SizedBox(
                height: 25,
              ),
              // google and apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedImageButton(
                    imagePath: "lib/assets/images/google_logo.png",
                    onPressed: () => googleLogin(),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  // Apple logo image
                  AnimatedImageButton(
                    imagePath: "lib/assets/images/facebook_logo.png",
                    onPressed: () => facebookLogin(),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              // not a member? register now!
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Not a member?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: registerNow,
                    child: const Text(
                      "Register now!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
