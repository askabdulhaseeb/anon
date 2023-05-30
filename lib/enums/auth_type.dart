enum AuthType {
  facebook('assets/icons/facebook-icon.png', 'Facebook', 'facebook'),
  apple('assets/icons/apple-icon.png', 'Apple', 'apple'),
  google('assets/icons/google-icon.png', 'Google', 'google'),
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