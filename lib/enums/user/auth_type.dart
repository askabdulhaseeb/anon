import 'package:hive/hive.dart';
part 'auth_type.g.dart';

@HiveType(typeId: 13)
enum AuthType {
  @HiveField(0)
  facebook('assets/icons/facebook-icon.png', 'Facebook', 'facebook'),
  @HiveField(1)
  apple('assets/icons/apple-icon.png', 'Apple', 'apple'),
  @HiveField(2)
  google('assets/icons/google-icon.png', 'Google', 'google'),
  @HiveField(3)
  email('', 'Email', 'email');

  const AuthType(this.icon, this.title, this.json);
  final String icon;
  final String title;
  final String json;
}

class AuthTypeConvertor {
  AuthType toEnum(String type) {
    switch (type) {
      case 'facebook':
        return AuthType.facebook;
      case 'apple':
        return AuthType.apple;
      case 'google':
        return AuthType.google;
      case 'email':
        return AuthType.email;
      default:
        return AuthType.email;
    }
  }
}
