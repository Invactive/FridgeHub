import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import '../amplifyconfiguration.dart';

class AmazonLoginPage extends StatefulWidget {
  const AmazonLoginPage({super.key});

  @override
  State<AmazonLoginPage> createState() => _AmazonLoginPageState();
}

class _AmazonLoginPageState extends State<AmazonLoginPage> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
      safePrint('Successfully configured');
    } on Exception catch (e) {
      safePrint('Error configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        builder: Authenticator.builder(),
        home: Scaffold(
          backgroundColor: Colors.grey[200],
          body: const Center(
            child: Text('You are logged in!'),
          ),
        ),
      ),
    );
  }
}
