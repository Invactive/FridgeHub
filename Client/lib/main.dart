import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgehub/constants/routes.dart';
import 'package:fridgehub/helpers/loading/loading_screen.dart';
import 'package:fridgehub/services/auth/bloc/auth_event.dart';
import 'package:fridgehub/services/auth/bloc/auth_state.dart';
import 'package:fridgehub/services/auth/custom_amplify_auth_provider.dart';
import 'package:fridgehub/services/auth/custom_aws_auth_provider.dart';
import 'package:fridgehub/views/authorization/forgot_password_entry_view.dart';
import 'package:fridgehub/views/authorization/new_password_view.dart';
import 'package:fridgehub/views/authorization/register_view.dart';
import 'package:fridgehub/views/authorization/verify_code_view.dart';
import 'package:fridgehub/views/home_view.dart';
import 'package:fridgehub/views/login_view.dart';

import 'services/auth/bloc/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: 'FridgeHub',
      debugShowCheckedModeBanner: false,
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(CustomAmplifyAuthProvider()),
        child: const MainView(),
      ),
    ),
  );
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment...',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        // Current state log
        devtools.log("STATE: ${state.toString()}");
        if (state is AuthStateLoggedIn) {
          return const HomeView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateNeedsCodeConfirmation) {
          return const VerifyCodeView();
        } else if (state is AuthStateNeedsPasswordConfirmation) {
          return const NewPasswordView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordEntryView();
        } else {
          return Scaffold(
            resizeToAvoidBottomInset: false,
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
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("lib/assets/images/fridgehub_logo.png"),
                    alignment: Alignment.topCenter,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
