import 'package:hive/hive.dart';

import '../../database/firebase/auth_methods.dart';
import '../../enums/chat/chat_member_role.dart';
import '../../functions/time_functions.dart';
part 'chat_group_member.g.dart';

@HiveType(typeId: 41)
class ChatMember {
  ChatMember({
    required this.uid,
    ChatMemberRole? role,
    String? addedBy,
    bool? invitationAccepted,
    DateTime? memberSince,
  })  : role = role ?? ChatMemberRole.member,
        addedBy = addedBy ?? AuthMethods.uid,
        invitationAccepted = invitationAccepted ?? false,
        memberSince = memberSince ?? DateTime.now();

  @HiveField(0)
  final String uid;
  @HiveField(1) // Class Code: 410
  final ChatMemberRole role;
  @HiveField(2)
  final String addedBy;
  @HiveField(3)
  final bool invitationAccepted;
  @HiveField(4)
  final DateTime memberSince;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'role': role.json,
      'added_by': addedBy,
      'invitation_accepted': invitationAccepted,
      'member_since': memberSince,
    };
  }

  // ignore: sort_constructors_first
  factory ChatMember.fromMap(Map<String, dynamic> map) {
    return ChatMember(
      uid: map['uid'] ?? '',
      role: ChatMemberRoleConvertor().fromMap(map['role']),
      addedBy: map['added_by'] ?? '',
      invitationAccepted: map['invitation_accepted'] ?? false,
      memberSince: TimeFun.parseTime(map['member_since']),
    );
  }
}
