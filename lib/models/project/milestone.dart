import 'package:hive_flutter/hive_flutter.dart';

import '../../database/firebase/auth_methods.dart';
import '../../enums/project/milestone_history_type.dart';
import '../../enums/project/milestone_status.dart';
import '../../functions/time_functions.dart';
import 'milestone_history.dart';
part 'milestone.g.dart';

@HiveType(typeId: 34)
class Milestone extends HiveObject {
  Milestone({
    required this.milestoneID,
    // required this.projectID,
    required this.title,
    // required this.description,
    required this.payment,
    required this.index,
    this.completedTime,
    this.deadline,
    this.currency = 'USD',
    this.startingTime,
    String? createdBy,
    List<String>? assignTo,
    List<MilestoneHistory>? history,
    MilestoneStatus? status,
    this.isCompleted = false,
    DateTime? createdTime,
  })  : createdTime = createdTime ?? DateTime.now(),
        createdBy = createdBy ?? AuthMethods.uid,
        assignTo = assignTo ?? <String>[],
        status = status ?? MilestoneStatus.inActive,
        history = history ??
            <MilestoneHistory>[
              MilestoneHistory(type: MilestoneHistoryType.start)
            ];

  @HiveField(0)
  final String milestoneID;
  // @HiveField(1)
  // final String projectID;
  @HiveField(2)
  String title;
  // @HiveField(3)
  // final String description;
  @HiveField(4)
  DateTime? deadline;
  @HiveField(5)
  DateTime? startingTime;
  @HiveField(6)
  DateTime? completedTime;
  @HiveField(7)
  double payment;
  @HiveField(8)
  final String currency;
  @HiveField(9)
  final String createdBy;
  @HiveField(10)
  final List<String> assignTo;
  @HiveField(11)
  final List<MilestoneHistory> history;
  @HiveField(12)
  bool isCompleted;
  @HiveField(13, defaultValue: 0)
  final int index;
  @HiveField(14, defaultValue: MilestoneStatus.inActive)
  MilestoneStatus status;
  @HiveField(15)
  DateTime createdTime;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'milestone_id': milestoneID,
      'index': index,
      // 'project_id': projectID,
      'title': title,
      'deadline': deadline,
      'created_time': createdTime,
      'starting_time': startingTime,
      'completed_time': completedTime,
      'payment': payment,
      'currency': currency,
      'created_by': createdBy,
      'assign_to': assignTo,
      'status': status.json,
      'history': history.map((MilestoneHistory x) => x.toMap()).toList(),
      'is_completed': isCompleted,
    };
  }

  // ignore: sort_constructors_first
  factory Milestone.fromMap(Map<String, dynamic> map) {
    return Milestone(
      milestoneID: map['milestone_id'] ?? '',
      index: map['index'] ?? 0,
      // projectID: map['project_id'] ?? '',
      title: map['title'] ?? '',
      // description: map['description'] ?? '',
      deadline: TimeFun.parseTime(map['deadline']),
      createdTime: TimeFun.parseTime(map['created_time']),
      startingTime: TimeFun.parseTime(map['starting_time']),
      completedTime: map['completed_time'] != null
          ? TimeFun.parseTime(map['completed_time'])
          : null,
      payment:
          map['created_by'] != AuthMethods.uid ? 0.0 : map['payment'] ?? 0.0,
      currency: map['currency'] ?? 'USD',
      createdBy: map['created_by'] ?? '',
      assignTo: List<String>.from((map['assign_to'] as List<dynamic>)),
      history: List<MilestoneHistory>.from(
        ((map['history'] ?? <dynamic>[]) as List<dynamic>)
            .map<MilestoneHistory>((dynamic x) =>
                MilestoneHistory.fromMap(x as Map<String, dynamic>)),
      ),
      status: MilestoneStatusConvertor()
          .toEnum(map['status'] ?? MilestoneStatus.inActive.json),
      isCompleted: map['is_completed'] ?? false,
    );
  }

  void statusUpdate(MilestoneStatus value) {
    status = value;
    if (value == MilestoneStatus.active) {
      isCompleted = false;
      startingTime = DateTime.now();
    } else if (value == MilestoneStatus.done ||
        MilestoneStatus.cancel == value) {
      isCompleted = true;
      completedTime = DateTime.now();
    }
  }
}
