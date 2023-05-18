import 'package:flutter/material.dart';
import 'package:fridge_hub/components/login_button.dart';
import 'package:fridge_hub/components/login_textfield.dart';
import 'package:fridge_hub/components/square_tile.dart';

import 'amazon_login_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() {
    print('Sign In Clicked!');
  }

  void forgotPassword() {
    print('Forgot password Clicked!');
  }

  void registerNow() {
    print('Register now Clicked!');
  }

  void googleLogin() {
    print('Google login Clicked!');
  }

  void amazonLogin() {
    print('Apple login Clicked!');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AmazonLoginPage(),
      ),
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
              const Text("Welcome back, you've been missed!",
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
              LoginTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
                prefixIcon: const Icon(Icons.lock),
              ),
              const SizedBox(
                height: 15,
              ),
              // password textfield
              LoginTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                prefixIcon: const Icon(Icons.person),
              ),
              const SizedBox(
                height: 15,
              ),
              // forgot password
              GestureDetector(
                onTap: forgotPassword,
                child: const Text("Forgot password?",
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
              LoginButton(
                onTap: signIn,
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
                height: 15,
              ),
              // google and apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google logo image
                  GestureDetector(
                      onTap: googleLogin,
                      child: const SquareTile(
                          imagePath: "lib/assets/images/google_logo.png")),
                  const SizedBox(
                    width: 30,
                  ),
                  // Apple logo image
                  GestureDetector(
                      onTap: amazonLogin,
                      child: const SquareTile(
                          imagePath: "lib/assets/images/amazon_logo.png"))
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
