import 'package:fridgehub/services/auth/custom_auth_user.dart';

abstract class CustomAwsAuthProvider {
  Future<void> configureAmplify();

  Future<bool> get isUserSignedIn;

  Future<CustomAuthUser?> get getCurrentUser;

  Future<CustomAuthUser> signUpUserWithCognito({
    required String nickname,
    required String email,
    required String password,
  });

  Future<void> signInUserWithGoogle();

  Future<void> confirmUser({
    required String email,
    required String confirmationCode,
  });

  Future<void> resendConfirmationCode({
    required String email,
  });

  Future<CustomAuthUser> signInUser({
    required String email,
    required String password,
  });

  Future<void> signOutCurrentUser();

  Future<void> resetPassword({required String toEmail});

  Future<void> confirmResetPassword({
    required String email,
    required String newPassword,
    required String confirmationCode,
  });
}
