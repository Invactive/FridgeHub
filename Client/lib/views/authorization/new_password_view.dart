import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Project Packages
import 'package:fridgehub/components/animated_text_button.dart';
import 'package:fridgehub/components/custom_password_textfield.dart';
import 'package:fridgehub/constants/ui.dart';
import 'package:fridgehub/services/auth/bloc/auth_bloc.dart';
import 'package:fridgehub/services/auth/bloc/auth_event.dart';
import 'package:fridgehub/services/auth/bloc/auth_state.dart';
import 'package:fridgehub/views/authorization/forgot_password_code_view.dart';
import 'package:fridgehub/views/login_view.dart';
// Addons Packages
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

class NewPasswordView extends StatefulWidget {
  const NewPasswordView({super.key});

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  @override
  initState() {
    super.initState();
  }

  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
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
                  const Text(
                      "Enter a new password below to change your password",
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
                  // password textfield
                  CustomPasswordTextField(
                    controller: passwordController,
                    hintText: 'New Password',
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  const SizedBox(
                    height: separationHeight,
                  ),
                  // confirm password textfield
                  CustomPasswordTextField(
                    controller: passwordConfirmController,
                    hintText: 'Confirm New Password',
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  const SizedBox(
                    height: separationHeight,
                  ),
                  // confirm button
                  AnimatedTextButton(
                    text: "Confirm",
                    // TODO confirm password
                    onPressed: () async {},
                  ),
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
