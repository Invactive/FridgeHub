import 'package:flutter/material.dart';
// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
// Project Packages
import 'package:fridgehub/components/animated_text_button.dart';
import 'package:fridgehub/constants/ui.dart';
import 'package:fridgehub/views/login_view.dart';
// Addons Packages
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';

class ForgotPasswordCodeView extends StatefulWidget {
  final String email;
  final String password;
  const ForgotPasswordCodeView({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<ForgotPasswordCodeView> createState() => _ForgotPasswordCodeViewState();
}

class _ForgotPasswordCodeViewState extends State<ForgotPasswordCodeView> {
  @override
  initState() {
    super.initState();
  }

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  String code = "";

  Future<void> confirmResetPassword({
    required String username,
    required String newPassword,
    required String confirmationCode,
  }) async {
    try {
      final result = await Amplify.Auth.confirmResetPassword(
        username: username,
        newPassword: newPassword,
        confirmationCode: confirmationCode,
      );
      safePrint('Password reset complete: ${result.isPasswordReset}');
      Fluttertoast.showToast(
          msg: "Password reset complete",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[400],
          textColor: Colors.black,
          fontSize: 16.0);
      if (!mounted) return;
      Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: const LoginView(),
            duration: const Duration(milliseconds: 400),
          ));
    } on AuthException catch (e) {
      safePrint('Error resetting password: ${e.message}');
      String message = e.message.endsWith('.')
          ? e.message.substring(0, e.message.length - 1)
          : e.message;
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[400],
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  Future<void> resetPassword(String username) async {
    try {
      final result = await Amplify.Auth.resetPassword(
        username: username,
      );
      await _handleResetPasswordResult(result);
    } on AuthException catch (e) {
      safePrint('Error resetting password: ${e.message}');
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
    Fluttertoast.showToast(
        msg: "Verification code resent",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[400],
        textColor: Colors.black,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: const LoginView(),
            duration: const Duration(milliseconds: 400),
          ),
        );
        return true;
      },
      child: GestureDetector(
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
                const Text(
                    "An E-Mail with with a verification code was just sent to",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.w400,
                    )),
                Text(widget.email,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(
                  height: 5,
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
                // resend code
                GestureDetector(
                  onTap: () => resetPassword(widget.email),
                  child: const Text("Resend code",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w600,
                      )),
                ),
                const SizedBox(
                  height: separationHeight,
                ),
                // confirm button
                AnimatedTextButton(
                  text: "Confirm",
                  onPressed: () => confirmResetPassword(
                    username: widget.email,
                    newPassword: widget.password,
                    confirmationCode: code,
                  ),
                ),
                const SizedBox(
                  height: separationHeight,
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
