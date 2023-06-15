// Amplify Flutter Packages
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// Generated in previous step
import '../amplifyconfiguration.dart';
import 'package:flutter/material.dart';
import 'package:fridge_hub/components/login_button.dart';
import 'package:fridge_hub/components/login_textfield.dart';
import 'package:fridge_hub/components/square_tile.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }

  Future<bool> isUserSignedIn() async {
    final result = await Amplify.Auth.fetchAuthSession();
    return result.isSignedIn;
  }

  Future<AuthUser> getCurrentUser() async {
    final user = await Amplify.Auth.getCurrentUser();
    return user;
  }

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

  void facebookLogin() {
    print('Facebook login Clicked!');
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      initialStep: AuthenticatorStep.signIn,
      child: MaterialApp(
        builder: Authenticator.builder(),
        home: const Scaffold(
          body: Center(
            child: Text('You are logged in!'),
          ),
        ),
      ),
    );
  }
}
