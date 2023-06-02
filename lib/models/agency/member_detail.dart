import 'package:hive/hive.dart';

import '../../enums/user/user_designation.dart';
import '../../functions/time_functions.dart';
part 'member_detail.g.dart';

@HiveType(typeId: 20)
class MemberDetail {
  MemberDetail({
    required this.uid,
    required this.designation,
    bool? isAccepted,
    bool? isPending,
    String? responcedBy,
    DateTime? requestTime,
    DateTime? responceTime,
  })  : isAccepted = isAccepted ?? false,
        isPending = isPending ?? true,
        responcedBy = responcedBy = '',
        requestTime = requestTime ?? DateTime.now(),
        responceTime = responceTime ?? DateTime.now();

  @HiveField(0)
  final String uid;
  @HiveField(1)
  bool isAccepted;
  @HiveField(2)
  bool isPending;
  @HiveField(3)
  final String responcedBy;
  @HiveField(4)
  final DateTime requestTime;
  @HiveField(5)
  DateTime responceTime;
  // Field 6 not for use
  @HiveField(7) // Class Code: 200
  UserDesignation designation;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'is_accepted': isAccepted,
      'is_pending': isPending,
      'responced_by': responcedBy,
      'request_time': requestTime,
      'responce_time': responceTime,
      'designation': designation.json,
    };
  }

  // ignore: sort_constructors_first
  factory MemberDetail.fromMap(Map<String, dynamic> map) {
    return MemberDetail(
      uid: map['uid'] ?? '',
      isAccepted: map['is_accepted'] ?? false,
      isPending: map['is_pending'] ?? true,
      responcedBy: map['responced_by'] ?? '',
      requestTime: TimeFun.parseTime(map['request_time']),
      responceTime: TimeFun.parseTime(map['responce_time']),
      designation: UserDesignationConvertor()
          .toEnum(map['designation'] ?? UserDesignation.employee),
    );
  }
}
