enum UserDesignation {
  admin('admin', 'Admin'),
  manager('manager', 'Manager'),
  developer('developer', 'Developer'),
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
