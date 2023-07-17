import 'package:hive/hive.dart';

import '../../database/firebase/auth_methods.dart';
import '../../enums/chat/chat_member_role.dart';
import '../../functions/time_functions.dart';
part 'board_member.g.dart';

@HiveType(typeId: 61)
class BoardMember {
  BoardMember({
    required this.uid,
    this.isRequestPending = true,
    this.invitationAccepted = false,
    String? addedBy,
    ChatMemberRole? role,
    DateTime? joiningDate,
    DateTime? lastUpdate,
  })  : addedBy = addedBy ?? AuthMethods.uid,
        role = role ?? ChatMemberRole.member,
        joiningDate = joiningDate ?? DateTime.now(),
        lastUpdate = lastUpdate ?? DateTime.now();

  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String addedBy;
  @HiveField(2)
  ChatMemberRole role;
  @HiveField(3)
  bool isRequestPending;
  @HiveField(4)
  bool invitationAccepted;
  @HiveField(5)
  final DateTime joiningDate;
  @HiveField(6)
  final DateTime lastUpdate;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'added_by': addedBy,
      'role': role.json,
      'is_request_pending': isRequestPending,
      'invitation_accepted': invitationAccepted,
      'joining_date': joiningDate,
      'last_update': lastUpdate,
    };
  }

  Map<String, dynamic> requestResponceMap() {
    return <String, dynamic>{
      'role': role.json,
      'is_request_pending': isRequestPending,
      'last_update': DateTime.now(),
    };
  }

  Map<String, dynamic> invitationResponceMap() {
    return <String, dynamic>{
      'invitation_accepted': invitationAccepted,
      'last_update': DateTime.now(),
    };
  }

  // ignore: sort_constructors_first
  factory BoardMember.fromMap(Map<String, dynamic> map) {
    return BoardMember(
      uid: map['uid'] ?? '',
      addedBy: map['added_by'] ?? '',
      role: ChatMemberRoleConvertor()
          .fromMap(map['role'] ?? ChatMemberRole.viewer.json),
      isRequestPending: map['is_request_pending'] ?? true,
      invitationAccepted: map['invitation_accepted'] ?? false,
      joiningDate: TimeFun.parseTime(map['joining_date']),
      lastUpdate: TimeFun.parseTime(map['last_update']),
    );
  }
}
