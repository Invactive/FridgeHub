import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

class AuthEventResendEmailVerification extends AuthEvent {
  final String email;
  const AuthEventResendEmailVerification(this.email);
}

class AuthEventRegisterWithCognito extends AuthEvent {
  final String nickname;
  final String email;
  final String password;
  const AuthEventRegisterWithCognito(this.nickname, this.email, this.password);
}

class AuthEventConfirmUser extends AuthEvent {
  final String code;
  final String email;
  const AuthEventConfirmUser(
    this.code,
    this.email,
  );
}

class AuthEventRegisterWithGoogle extends AuthEvent {
  const AuthEventRegisterWithGoogle();
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}
