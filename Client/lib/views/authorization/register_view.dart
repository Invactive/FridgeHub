import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgehub/constants/ui.dart';
import 'package:fridgehub/extensions/buildcontext/loc.dart';
import 'package:fridgehub/services/auth/auth_exceptions.dart';
import 'package:fridgehub/services/auth/bloc/auth_bloc.dart';
import 'package:fridgehub/services/auth/bloc/auth_event.dart';
import 'package:fridgehub/services/auth/bloc/auth_state.dart';
import 'package:fridgehub/services/auth/custom_amplify_auth_provider.dart';
import 'package:fridgehub/utilities/dialogs/error_dialog.dart';
import 'package:fridgehub/views/authorization/verify_code_view.dart';
import 'package:fridgehub/views/login_view.dart';
// Project Packages
import 'package:fridgehub/components/animated_text_button.dart';
import 'package:fridgehub/components/custom_textfield.dart';
import 'package:fridgehub/components/custom_password_textfield.dart';
// Addons Packages
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:email_validator/email_validator.dart';

import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _nickname;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _nickname = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nickname.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is InvalidPasswordException) {
            await showErrorDialog(
              context,
              context.loc.register_error_weak_password,
            );
          } else if (state.exception is InvalidParameterException) {
            await showErrorDialog(
              context,
              "Missing required parameter",
            );
          } else if (state.exception is InvalidNicknameAuthException) {
            await showErrorDialog(
              context,
              "Invalid nickname provided",
            );
          } else if (state.exception is UsernameExistsException) {
            await showErrorDialog(
              context,
              context.loc.register_error_email_already_in_use,
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              "Invalid email address format",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              "register_error_generic",
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
                      controller: _nickname,
                      hintText: 'Nickname',
                      obscureText: false,
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(Icons.person),
                    ),
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
                    // password textfield
                    CustomPasswordTextField(
                      controller: _password,
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    const SizedBox(
                      height: separationHeight,
                    ),
                    // sign up button
                    AnimatedTextButton(
                      text: "Sign Up",
                      onPressed: () async {
                        final nickname = _nickname.text.trim();
                        final email = _email.text.trim();
                        final password = _password.text.trim();
                        context.read<AuthBloc>().add(
                              AuthEventRegisterWithCognito(
                                nickname,
                                email,
                                password,
                              ),
                            );
                      },
                    ),
                    const SizedBox(
                      height: separationHeight,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
