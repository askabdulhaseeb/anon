import 'package:hive_flutter/hive_flutter.dart';

import '../../database/firebase/auth_methods.dart';
import '../../enums/project/milestone_history_type.dart';
import '../../functions/time_functions.dart';
part 'milestone_history.g.dart';

@HiveType(typeId: 35)
class MilestoneHistory {
  MilestoneHistory({
    required this.type,
    DateTime? actionTime,
    String? actionBy,
  })  : actionTime = actionTime ?? DateTime.now(),
        actionBy = actionBy ?? AuthMethods.uid;

  @HiveField(0)
  final DateTime actionTime;
  @HiveField(1)
  final MilestoneHistoryType type;
  @HiveField(2)
  final String actionBy;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'action_time': actionTime,
      'type': type.json,
      'action_by': actionBy,
    };
  }

  // ignore: sort_constructors_first
  factory MilestoneHistory.fromMap(Map<String, dynamic> map) {
    return MilestoneHistory(
      actionTime: TimeFun.parseTime(map['action_time']),
      type: MilestoneHistoryTypeConvertor()
          .toEnum(map['type'] ?? MilestoneHistoryType.cancel),
      actionBy: map['action_by'] ?? '',
    );
  }
}
