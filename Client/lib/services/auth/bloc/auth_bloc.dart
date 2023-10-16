import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:bloc/bloc.dart';
import 'package:fridgehub/services/auth/auth_exceptions.dart';
import 'package:fridgehub/services/auth/bloc/auth_event.dart';
import 'package:fridgehub/services/auth/bloc/auth_state.dart';
import 'package:fridgehub/services/auth/custom_amplify_auth_provider.dart';

import 'dart:developer' as devtools show log;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String? email;
  AuthBloc(CustomAmplifyAuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    // Initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.configureAmplify();
      final user = await provider.getCurrentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } else if (!user.isEmailVerified) {
        emit(AuthStateNeedsCodeConfirmation(
          exception: null,
          email: user.email,
          isLoading: false,
          loadingText: "Creating user, please wait...",
        ));
      } else {
        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));
      }
    });

    // Log In
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(
        exception: null,
        isLoading: true,
        loadingText: 'Logging in, please wait...',
      ));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.signInUser(
          email: email,
          password: password,
        );
        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));
      } on UserNotConfirmedException catch (e) {
        this.email = email;
        devtools.log("UserNotConfirmedException: $email");
        emit(
          AuthStateNeedsCodeConfirmation(
            exception: e,
            email: email,
            isLoading: false,
          ),
        );
      } on ConfirmSignInWithNewPasswordAuthException catch (e) {
        this.email = email;
        devtools.log("ConfirmSignInWithNewPasswordAuthException: $email");
        emit(AuthStateNeedsPasswordConfirmation(
          exception: e,
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });

    // Register with Cognito
    on<AuthEventRegisterWithCognito>((event, emit) async {
      final nickname = event.nickname;
      final email = event.email;
      final password = event.password;
      emit(
        const AuthStateRegistering(
          exception: null,
          isLoading: true,
          loadingText: "Registering, please wait...",
        ),
      );
      try {
        await provider.signUpUserWithCognito(
          nickname: nickname,
          email: email,
          password: password,
        );
        this.email = email;
      } on UserNotConfirmedException catch (e) {
        emit(
          AuthStateNeedsCodeConfirmation(
            exception: e,
            email: email,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          exception: e,
          isLoading: false,
          loadingText: null,
        ));
      }
    });

    // Confirm user with code
    on<AuthEventConfirmUser>((event, emit) async {
      final code = event.code;
      try {
        emit(AuthStateNeedsCodeConfirmation(
          exception: null,
          email: email!,
          isLoading: true,
          loadingText: "Checking code...",
        ));
        await provider.confirmUser(
          email: email!,
          confirmationCode: code,
        );
        devtools.log("CONFIRMED");
      } on CodeMismatchException catch (e) {
        emit(AuthStateNeedsCodeConfirmation(
          exception: e,
          email: email!,
          isLoading: false,
          loadingText: null,
        ));
      } on LimitExceededException catch (e) {
        emit(AuthStateNeedsCodeConfirmation(
          exception: e,
          email: email!,
          isLoading: false,
          loadingText: null,
        ));
      } on CodeDeliveryFailureException catch (e) {
        emit(AuthStateNeedsCodeConfirmation(
          exception: e,
          email: email!,
          isLoading: false,
          loadingText: null,
        ));
      } on Exception catch (e) {
        devtools.log(e.toString());
      }
    });

    // Resend email verification
    on<AuthEventResendEmailVerification>((event, emit) async {
      final email = event.email;
      try {
        await provider.resendConfirmationCode(email: email);
        emit(state);
      } on Exception catch (e) {
        devtools.log(e.toString());
      }
    });

    // Register with Google
    on<AuthEventRegisterWithGoogle>((event, emit) async {
      try {
        // TODO Google
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          exception: e,
          isLoading: false,
          loadingText: null,
        ));
      }
    });

    // Should register
    on<AuthEventShouldRegister>((event, emit) async {
      emit(
        const AuthStateRegistering(
          exception: null,
          isLoading: false,
          loadingText: null,
        ),
      );
    });

    // Log Out
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.signOutCurrentUser();
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });

    // Forgot password
    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: false,
      ));
      final email = event.email;
      if (email == null) {
        return; // user didn't provide email (isLoading is false)
      }

      // user provided password, proceed and isLoading == true
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: true,
      ));
      bool didSendEmail;
      Exception? exception;
      try {
        await provider.resetPassword(toEmail: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }

      // email sent
      emit(AuthStateForgotPassword(
        exception: exception,
        hasSentEmail: didSendEmail,
        isLoading: false,
      ));
    });
  }
}
