import 'package:flutter/material.dart';
// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:fridgehub/constants/ui.dart';
import 'package:fridgehub/extensions/buildcontext/loc.dart';
import 'package:fridgehub/services/auth/auth_exceptions.dart';
import 'package:fridgehub/services/auth/auth_service.dart';
import 'package:fridgehub/services/auth/bloc/auth_bloc.dart';
import 'package:fridgehub/services/auth/bloc/auth_event.dart';
import 'package:fridgehub/services/auth/bloc/auth_state.dart';
import 'package:fridgehub/utilities/dialogs/error_dialog.dart';
// import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:fridgehub/views/home_view.dart';
import 'package:fridgehub/views/authorization/register_view.dart';
import '../amplifyconfiguration.dart';
import 'package:fridgehub/views/authorization/forgot_password_entry_view.dart';
// Project Packages
import 'package:fridgehub/components/animated_indicator_text_button.dart';
import 'package:fridgehub/components/custom_textfield.dart';
import 'package:fridgehub/components/custom_password_textfield.dart';
import 'package:fridgehub/components/animated_image_button.dart';
// Addons Packages
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:email_validator/email_validator.dart';

import 'dart:developer' as devtools show log;

import 'package:fridgehub/services/auth/custom_amplify_auth_provider.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _email.text = "lihivana@hexi.pics	";
    _password.text = "asdf123\$";
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundException) {
            await showErrorDialog(
              context,
              context.loc.login_error_cannot_find_user,
            );
          } else if (state.exception is AuthValidationException) {
            await showErrorDialog(
              context,
              context.loc.login_error_wrong_credentials,
            );
          } else if (state.exception is UserNotConfirmedException) {
            await showErrorDialog(
              context,
              "User not confirmed",
            );
          } else if (state.exception is InvalidParameterException) {
            await showErrorDialog(
              context,
              "Missing required parameter",
            );
          } else if (state.exception is PasswordAttemptsExceededAuthException) {
            await showErrorDialog(
              context,
              "Password attempts exceeded",
            );
          } else if (state.exception
              is ConfirmSignInWithNewPasswordAuthException) {
            await showErrorDialog(
              context,
              "Confirm sign in with new password",
            );
          } else if (state.exception is NotAuthorizedServiceException) {
            await showErrorDialog(
              context,
              "Wrong credentials",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              context.loc.login_error_auth_error,
            );
          }
        }
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
                    controller: _email,
                    hintText: 'E-Mail',
                    obscureText: false,
                    autocorrect: false,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email),
                  ),
                  const SizedBox(
                    height: separationHeight,
                  ),
                  // password textfield
                  CustomPasswordTextField(
                    controller: _password,
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  const SizedBox(
                    height: separationHeight,
                  ),
                  // forgot password
                  GestureDetector(
                    onTap: () {
                      context.read<AuthBloc>().add(
                            const AuthEventForgotPassword(),
                          );
                    },
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
                    height: 20,
                  ),
                  // sign in button
                  AnimatedIndicatorTextButton(
                    text: "Sign In",
                    isLoading: false,
                    onPressed: () async {
                      final email = _email.text.trim();
                      final password = _password.text.trim();
                      context.read<AuthBloc>().add(
                            AuthEventLogIn(
                              email,
                              password,
                            ),
                          );
                    },
                  ),
                  const SizedBox(
                    height: separationHeight,
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
                        onPressed: () async {
                          await showErrorDialog(
                            context,
                            "Google sign in not inplemented yet.",
                          );
                        },
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      // Apple logo image
                      AnimatedImageButton(
                        imagePath: "lib/assets/images/facebook_logo.png",
                        onPressed: () async {
                          await showErrorDialog(
                            context,
                            "Facebook sign in not inplemented yet.",
                          );
                        },
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
                        onTap: () {
                          context.read<AuthBloc>().add(
                                const AuthEventShouldRegister(),
                              );
                        },
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
