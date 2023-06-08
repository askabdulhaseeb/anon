import 'package:hive/hive.dart';
part 'chat_member_role.g.dart';

@HiveType(typeId: 410)
enum ChatMemberRole {
  @HiveField(0)
  admin('admin', 'Admin'),
  @HiveField(1)
  member('member', 'Member'),
  @HiveField(2)
  viewer('viewer', 'View Only');

  const ChatMemberRole(this.json, this.title);
  final String json;
  final String title;
}

class ChatMemberRoleConvertor {
  ChatMemberRole fromMap(String role) {
    if (role == ChatMemberRole.admin.json) {
      return ChatMemberRole.admin;
    } else if (role == ChatMemberRole.member.json) {
      return ChatMemberRole.member;
    } else {
      return ChatMemberRole.viewer;
    }
  }
}
