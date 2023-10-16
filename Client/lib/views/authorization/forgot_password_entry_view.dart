import 'package:flutter/material.dart';
// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgehub/constants/ui.dart';
import 'package:fridgehub/extensions/buildcontext/loc.dart';
import 'package:fridgehub/services/auth/bloc/auth_bloc.dart';
import 'package:fridgehub/services/auth/bloc/auth_event.dart';
import 'package:fridgehub/services/auth/bloc/auth_state.dart';
import 'package:fridgehub/utilities/dialogs/error_dialog.dart';
import 'package:fridgehub/utilities/dialogs/password_reset_email_sent_dialog.dart';
import 'package:fridgehub/views/login_view.dart';
import 'package:fridgehub/views/authorization/new_password_view.dart';
// Project Packages
import 'package:fridgehub/components/animated_text_button.dart';
import 'package:fridgehub/components/custom_textfield.dart';
// Addons Packages
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:page_transition/page_transition.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:async';

import 'dart:developer' as devtools show log;

class ForgotPasswordEntryView extends StatefulWidget {
  const ForgotPasswordEntryView({super.key});

  @override
  State<ForgotPasswordEntryView> createState() =>
      _ForgotPasswordEntryViewState();
}

class _ForgotPasswordEntryViewState extends State<ForgotPasswordEntryView> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _email.clear();
            await showPasswordResetSentDialog(context);
          }
          if (!mounted) return;
          if (state.exception != null) {
            await showErrorDialog(
              context,
              context.loc.forgot_password_view_generic_error,
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
                      "Enter the email address associated with your account",
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
                    height: separationHeight,
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
                  // confirm button
                  AnimatedTextButton(
                      text: "Confirm",
                      onPressed: () => context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          )),
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
