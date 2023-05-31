enum UserType {
  user('user', 'Employee / Agency Owner'),
  client('client', 'Client');

  const UserType(this.json, this.title);
  final String json;
  final String title;
}

class UserTypeConvertor {
  UserType toEnum(String type) {
    if (UserType.user.json == type) return UserType.user;
    return UserType.client;
  }
}
