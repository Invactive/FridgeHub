import 'package:flutter/foundation.dart';

@immutable
class CustomAuthUser {
  final String id;
  final String email;
  final String nickname;
  final bool isEmailVerified;

  const CustomAuthUser({
    required this.id,
    required this.email,
    required this.nickname,
    required this.isEmailVerified,
  });

  factory CustomAuthUser.fromAttributes(
          Map<String, dynamic> userAttributesMap) =>
      CustomAuthUser(
        id: userAttributesMap['id'] as String,
        email: userAttributesMap['email']! as String,
        nickname: userAttributesMap['nickname'] as String,
        isEmailVerified: userAttributesMap['isEmailVerified'] as bool,
      );
}
