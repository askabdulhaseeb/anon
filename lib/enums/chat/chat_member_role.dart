import 'package:hive/hive.dart';
part 'chat_member_role.g.dart';

@HiveType(typeId: 43)
enum ChatMemberRole {
  // 0,1,2 not for use
  @HiveField(3, defaultValue: ChatMemberRole.admin)
  admin('admin', 'Admin'),
  @HiveField(4, defaultValue: ChatMemberRole.member)
  member('member', 'Member'),
  @HiveField(5, defaultValue: ChatMemberRole.viewer)
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
