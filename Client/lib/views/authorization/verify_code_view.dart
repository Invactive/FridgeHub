import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgehub/constants/ui.dart';
import 'package:fridgehub/extensions/buildcontext/loc.dart';
import 'package:fridgehub/services/auth/bloc/auth_bloc.dart';
import 'package:fridgehub/services/auth/bloc/auth_event.dart';
import 'package:fridgehub/services/auth/bloc/auth_state.dart';
import 'package:fridgehub/services/auth/custom_auth_user.dart';
import 'package:fridgehub/utilities/dialogs/error_dialog.dart';
// Project Packages
// import 'package:fridge_hub/pages/home_page.dart';
import 'package:fridgehub/views/login_view.dart';
import 'package:fridgehub/components/animated_text_button.dart';
// Addons Packages
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import 'dart:async';

import 'dart:developer' as devtools show log;

class VerifyCodeView extends StatefulWidget {
  const VerifyCodeView({super.key});

  @override
  State<VerifyCodeView> createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> {
  late final TextEditingController _code;
  late bool _isWrongCodeTextVisible;
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  @override
  initState() {
    _code = TextEditingController();
    _isWrongCodeTextVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previousState, currentState) {
        if (previousState is AuthStateLoggedOut) {
          devtools.log("Previous AuthStateLoggedOut");
          context.read<AuthBloc>().add(AuthEventResendEmailVerification(
              context.read<AuthBloc>().email!));
        } else {
          devtools.log("Previous else");
          // context.read<AuthBloc>().add(AuthEventResendEmailVerification(
          //     context.read<AuthBloc>().email!));
        }
        return true;
      },
      listener: (context, state) async {
        if (state is AuthStateNeedsCodeConfirmation) {
          if (state.exception is CodeMismatchException) {
            // await showErrorDialog(
            //   context,
            //   "Invalid verification code provided, please try again",
            // );
            errorController.add(ErrorAnimationType.shake);
            Vibrate.feedback(FeedbackType.warning);
            await Future.delayed(const Duration(milliseconds: 300));
            _code.clear();
            setState(() {
              _isWrongCodeTextVisible = true;
            });
          } else if (state.exception is CodeDeliveryFailureException) {
            await showErrorDialog(
              context,
              "Code delivery failure",
            );
          } else if (state.exception is LimitExceededException) {
            await showErrorDialog(
              context,
              "Attempt limit exceeded, please try after some time",
            );
          }
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          context.read<AuthBloc>().add(
                const AuthEventLogOut(),
              );
          return false;
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
                children: [
                  // logo
                  const Image(
                    image: AssetImage("lib/assets/images/fridgehub_logo.png"),
                    alignment: Alignment.topCenter,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // welcome back text
                  const Text("Please enter a verification code",
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
                      "A verification code has been sent to your E-Mail address",
                      textAlign: TextAlign.center,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: PinCodeTextField(
                      controller: _code,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      cursorColor: Colors.blue,
                      useHapticFeedback: true,
                      hapticFeedbackTypes: HapticFeedbackTypes.heavy,
                      pinTheme: PinTheme(
                        activeColor: Colors.black,
                        selectedColor: Colors.blue,
                        inactiveColor: Colors.grey,
                        errorBorderColor: Colors.red[300],
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
                      onChanged: (value) async {
                        // Managed by TextEditingController _code
                      },
                      onTap: () {
                        setState(() {
                          _isWrongCodeTextVisible = false;
                        });
                      },
                      appContext: context,
                    ),
                  ),
                  SizedBox(
                    height: separationHeight,
                    child: Text(
                      _isWrongCodeTextVisible ? "Wrong code" : "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red[300],
                        fontSize: 15,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: separationHeight,
                  ),
                  // resend code
                  GestureDetector(
                    onTap: () async {
                      devtools.log(context.read<AuthBloc>().email!);
                      context.read<AuthBloc>().add(
                          AuthEventResendEmailVerification(
                              context.read<AuthBloc>().email!));
                    },
                    child: const Text("Resend code",
                        textAlign: TextAlign.center,
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
                      onPressed: () async {
                        devtools.log("CODE: $_code");
                        devtools
                            .log("EMAIL: ${context.read<AuthBloc>().email!}");
                        context.read<AuthBloc>().add(AuthEventConfirmUser(
                            context.read<AuthBloc>().email!, _code.text));
                      }),
                  const SizedBox(
                    height: separationHeight,
                  ),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
