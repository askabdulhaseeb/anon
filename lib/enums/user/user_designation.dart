import 'package:hive/hive.dart';
part 'user_designation.g.dart';

@HiveType(typeId: 200)
enum UserDesignation {
  @HiveField(0)
  admin('admin', 'Admin'),
  @HiveField(1)
  manager('manager', 'Manager'),
  @HiveField(2)
  developer('developer', 'Developer'),
  @HiveField(3)
  employee('employee', 'Employee');

  const UserDesignation(this.json, this.title);

  final String title;
  final String json;
}

class UserDesignationConvertor {
  UserDesignation toEnum(String designation) {
    if (designation == UserDesignation.admin.json) {
      return UserDesignation.admin;
    } else if (designation == UserDesignation.manager.json) {
      return UserDesignation.manager;
    } else if (designation == UserDesignation.developer.json) {
      return UserDesignation.developer;
    } else {
      return UserDesignation.employee;
    }
  }
}
