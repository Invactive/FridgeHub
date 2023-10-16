// import 'package:fridgehub/services/auth/aws_auth_provider.dart';
// AWS
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:fridgehub/amplifyconfiguration.dart';
import 'package:fridgehub/services/auth/auth_exceptions.dart';
import 'package:fridgehub/services/auth/custom_auth_user.dart';

import 'dart:developer' as devtools show log;

import 'package:fridgehub/services/auth/custom_aws_auth_provider.dart';

class CustomAmplifyAuthProvider implements CustomAwsAuthProvider {
  @override
  Future<void> configureAmplify() async {
    try {
      // TODO: AWS Analytics plugin
      // final analyticsPlugin = AmplifyAnalyticsPinpoint();
      final authPlugin = AmplifyAuthCognito();
      await Amplify.addPlugins([
        authPlugin,
      ]);
      await Amplify.configure(amplifyconfig);
      // await Future.delayed(const Duration(seconds: 2));
      devtools.log('Successfully configured Amplify');
    } on NetworkException catch (e) {
      devtools.log('Error: $e');
    } on Exception catch (e) {
      devtools.log('Error configuring Amplify: $e');
    }
  }

  @override
  Future<bool> get isUserSignedIn async {
    final result = await Amplify.Auth.fetchAuthSession();
    return result.isSignedIn;
  }

  @override
  Future<CustomAuthUser?> get getCurrentUser async {
    Map<String, dynamic> userAttribsMap = {
      'id': null,
      'isEmailVerified': false,
      'nickname': null,
      'email': null,
    };
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      for (var attr in attributes) {
        switch (attr.userAttributeKey) {
          case CognitoUserAttributeKey.sub:
            userAttribsMap['id'] = attr.value;
            break;
          case CognitoUserAttributeKey.emailVerified:
            if (attr.value == 'true') {
              userAttribsMap['isEmailVerified'] = true;
            }
            break;
          case CognitoUserAttributeKey.nickname:
            userAttribsMap['nickname'] = attr.value;
            break;
          case CognitoUserAttributeKey.email:
            userAttribsMap['email'] = attr.value;
            break;
          default:
            // Handle other attributes if needed
            break;
        }
      }
      if (userAttribsMap['id'] != null) {
        return CustomAuthUser.fromAttributes(userAttribsMap);
      } else {
        return null;
      }
    } on AuthException catch (e) {
      devtools.log('Error fetching user attributes: ${e.message}');
      return null;
    }
  }

  @override
  Future<CustomAuthUser> signUpUserWithCognito({
    required String nickname,
    required String email,
    required String password,
  }) async {
    try {
      final userAttributes = {
        AuthUserAttributeKey.email: email,
        AuthUserAttributeKey.nickname: nickname,
        // additional attributes as needed
      };
      if (nickname.isEmpty) {
        throw InvalidNicknameAuthException();
      }
      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: userAttributes,
        ),
      );
      devtools.log(result.toString());
      if (!result.isSignUpComplete) {
        switch (result.nextStep.signUpStep) {
          case AuthSignUpStep.confirmSignUp:
            throw const UserNotConfirmedException("User not confirmed");
          case AuthSignUpStep.done:
            final user = await getCurrentUser;
            return user!;
        }
      } else {
        final user = await getCurrentUser;
        return user!;
      }
    } on InvalidParameterException catch (e) {
      devtools.log('Error: $e');
      devtools.log('Error message: ${e.message}');
      if (e.message == "Invalid email address format.") {
        throw InvalidEmailAuthException();
      }
      rethrow;
    } on InvalidNicknameAuthException catch (_) {
      devtools.log('InvalidNicknameAuthException');
      rethrow;
    } on InvalidPasswordException catch (e) {
      devtools.log('Error: $e');
      devtools.log('Error message: ${e.message}');
      rethrow;
    } on UsernameExistsException catch (e) {
      devtools.log('Error: $e');
      devtools.log('Error message: ${e.message}');
      rethrow;
    } on UserNotConfirmedAuthException catch (e) {
      devtools.log('Error: $e');
      devtools.log('Error message: ${e.message}');
      rethrow;
    } on AuthException catch (e) {
      // Any other AuthException
      devtools.log('Error: $e');
      devtools.log('Error message: ${e.message}');
      rethrow;
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> signInUserWithGoogle() async {
    try {
      final result =
          await Amplify.Auth.signInWithWebUI(provider: AuthProvider.google);
      devtools.log('Sign in Google result: $result');
    } on AmplifyException catch (e) {
      // TODO: sign up Google exceptions
      devtools
          .log('SignIn Google underlying exception: ${e.underlyingException}');
      devtools.log('SignIn Google error: $e');
      devtools.log('SignIn Google error message: ${e.message}');
    }
  }

  @override
  Future<void> confirmUser({
    required String email,
    required String confirmationCode,
  }) async {
    try {
      // final result = await Amplify.Auth.confirmSignUp(
      //   username: email,
      //   confirmationCode: confirmationCode,
      // );
      throw const CodeMismatchException("asd");
      // switch (result.nextStep.signUpStep) {
      //   case AuthSignUpStep.confirmSignUp:
      //     throw const UserNotConfirmedException("User not confirmed");
      //   case AuthSignUpStep.done:
      //     throw UserNotLoggedInAuthException();
      // }
    } on UserNotConfirmedException catch (e) {
      devtools.log('Error: $e');
      rethrow;
    } on CodeMismatchException catch (e) {
      devtools.log('Error: $e');
      devtools.log('Error message: ${e.message}');
      rethrow;
    } on LimitExceededException catch (e) {
      devtools.log('Error: $e');
      rethrow;
    } on CodeDeliveryFailureException catch (e) {
      devtools.log('Error: $e');
      devtools.log('Error message: ${e.message}');
      rethrow;
    } on AuthException catch (e) {
      devtools.log('Error: $e');
      devtools.log('Error message: ${e.message}');
      rethrow;
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> resendConfirmationCode({
    required String email,
  }) async {
    try {
      final result = await Amplify.Auth.resendSignUpCode(
        username: email,
      );
      devtools.log(result.toString());
    } on AuthException catch (e) {
      // TODO: resend verification code exceptions
      devtools.log('Error: $e');
      devtools.log('Error message: ${e.message}');
    }
  }

  @override
  Future<CustomAuthUser> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );
      devtools.log(result.toString());
      if (!result.isSignedIn) {
        switch (result.nextStep.signInStep) {
          case AuthSignInStep.confirmSignInWithNewPassword:
            throw ConfirmSignInWithNewPasswordAuthException();
          case AuthSignInStep.confirmSignUp:
            throw const UserNotConfirmedException("User not confirmed");
          default:
            throw UserNotLoggedInAuthException();
        }
      } else {
        final user = await getCurrentUser;
        return user!;
      }
    } on UserNotFoundException catch (e) {
      devtools.log('Error: $e');
      devtools.log('Error message: ${e.message}');
      rethrow;
    } on ConfirmSignInWithNewPasswordAuthException catch (e) {
      devtools.log('Error: $e');
      rethrow;
    } on InvalidParameterException catch (e) {
      devtools.log('Error: $e');
      devtools.log('Error message: ${e.message}');
      rethrow;
    } on UserNotConfirmedException catch (e) {
      devtools.log('Error: $e');
      rethrow;
    } on AuthValidationException catch (e) {
      devtools.log('Error: $e');
      devtools.log('Error message: ${e.message}');
      rethrow;
    } on NotAuthorizedServiceException catch (e) {
      devtools.log('Error: $e');
      devtools.log('Error message: ${e.message}');
      if (e.message == "Password attempts exceeded") {
        throw PasswordAttemptsExceededAuthException();
      }
      rethrow;
    } on AuthException catch (e) {
      // Any other AuthException
      devtools.log('Error: $e');
      devtools.log('Error message: ${e.message}');
      rethrow;
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> signOutCurrentUser() async {
    final result = await Amplify.Auth.signOut();
    if (result is CognitoCompleteSignOut) {
      devtools.log('$result');
    } else if (result is CognitoFailedSignOut) {
      devtools.log('Error signing user out: ${result.exception.message}');
    }
  }

  @override
  Future<void> resetPassword({required String toEmail}) async {
    try {
      await Amplify.Auth.resetPassword(
        username: toEmail,
      );
    } on AuthException catch (e) {
      // TODO: reset password exceptions
      devtools
          .log('resetPassword underlying exception: ${e.underlyingException}');
      devtools.log('resetPassword error: $e');
      devtools.log('resetPassword error message: ${e.message}');
    }
  }

  @override
  Future<void> confirmResetPassword({
    required String email,
    required String newPassword,
    required String confirmationCode,
  }) async {
    try {
      final result = await Amplify.Auth.confirmResetPassword(
        username: email,
        newPassword: newPassword,
        confirmationCode: confirmationCode,
      );
      devtools.log(
          'confirmResetPassword reset complete: ${result.isPasswordReset}');
    } on AuthException catch (e) {
      devtools.log(
          'confirmResetPassword underlying exception: ${e.underlyingException}');
      devtools.log('confirmResetPassword error: $e');
      devtools.log('confirmResetPassword error message: ${e.message}');
    }
  }
}
