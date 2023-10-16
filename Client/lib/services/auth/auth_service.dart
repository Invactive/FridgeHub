import 'package:fridgehub/services/auth/custom_amplify_auth_provider.dart';
import 'package:fridgehub/services/auth/custom_auth_user.dart';

class AwsAuthService implements CustomAmplifyAuthProvider {
  final CustomAmplifyAuthProvider provider;
  const AwsAuthService(this.provider);

  factory AwsAuthService.awsAmplifyAuth() =>
      AwsAuthService(CustomAmplifyAuthProvider());

  @override
  Future<void> configureAmplify() => provider.configureAmplify();

  @override
  Future<bool> get isUserSignedIn => provider.isUserSignedIn;

  @override
  Future<CustomAuthUser?> get getCurrentUser => provider.getCurrentUser;

  @override
  Future<CustomAuthUser> signUpUserWithCognito(
          {required String email,
          required String password,
          required String nickname}) =>
      provider.signUpUserWithCognito(
        email: email,
        password: password,
        nickname: nickname,
      );

  @override
  Future<void> signInUserWithGoogle() => provider.signInUserWithGoogle();

  @override
  Future<void> confirmUser({
    required String email,
    required String confirmationCode,
  }) =>
      provider.confirmUser(
        email: email,
        confirmationCode: confirmationCode,
      );

  @override
  Future<void> resendConfirmationCode({
    required String email,
  }) =>
      provider.resendConfirmationCode(email: email);

  @override
  Future<CustomAuthUser> signInUser({
    required String email,
    required String password,
  }) =>
      provider.signInUser(
        email: email,
        password: password,
      );

  @override
  Future<void> signOutCurrentUser() => provider.signOutCurrentUser();

  @override
  Future<void> resetPassword({required String toEmail}) =>
      provider.resetPassword(toEmail: toEmail);

  @override
  Future<void> confirmResetPassword(
          {required String email,
          required String newPassword,
          required String confirmationCode}) =>
      provider.confirmResetPassword(
        email: email,
        newPassword: newPassword,
        confirmationCode: confirmationCode,
      );
}
