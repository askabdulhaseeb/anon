import 'package:hive/hive.dart';
part 'user_type.g.dart';

@HiveType(typeId: 12)
enum UserType {
  @HiveField(0)
  user('user', 'Employee / Agency Owner'),
  @HiveField(1)
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
