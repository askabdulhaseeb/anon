import 'package:hive/hive.dart';

import '../../database/firebase/auth_methods.dart';
import '../../functions/time_functions.dart';
import '../../functions/unique_id_fun.dart';
import 'attachment.dart';
part 'note.g.dart';

@HiveType(typeId: 31)
class Note extends HiveObject {
  Note({
    required this.projectID,
    required this.description,
    required this.title,
    required this.attachments,
    required this.assignedTo,
    String? nodeID,
    String? createdBy,
    DateTime? createdTime,
    DateTime? deadline,
    DateTime? lastEditTime,
    bool? hasPublicAccess,
  })  : nodeID = nodeID ?? UniqueIdFun.unique(),
        createdBy = createdBy = AuthMethods.uid,
        createdTime = createdTime ?? DateTime.now(),
        deadline = deadline ?? DateTime.now(),
        lastEditTime = lastEditTime ?? DateTime.now(),
        hasPublicAccess = hasPublicAccess ?? true;

  @HiveField(0)
  final String nodeID;
  @HiveField(1)
  final String projectID;
  @HiveField(2)
  String title;
  @HiveField(3)
  String description;
  @HiveField(4) // Class Code: 32 & 33
  final List<Attachment> attachments;
  @HiveField(5)
  final List<String> assignedTo;
  @HiveField(6)
  final String createdBy;
  @HiveField(7)
  final DateTime createdTime;
  @HiveField(8)
  final DateTime deadline;
  @HiveField(9)
  final DateTime lastEditTime;
  @HiveField(10)
  bool hasPublicAccess;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'node_id': nodeID,
      'project_id': projectID,
      'title': title,
      'description': description,
      'attachments': attachments.map((Attachment x) => x.toMap()).toList(),
      'assigned_to': assignedTo,
      'created_by': createdBy,
      'created_time': createdTime,
      'deadline': deadline,
      'last_edit_time': lastEditTime,
    };
  }

  // ignore: sort_constructors_first
  factory Note.fromMap(Map<String, dynamic> map) {
    final List<dynamic> attachData = map['attachments'] ?? <dynamic>[];
    final List<Attachment> attach = <Attachment>[];
    for (dynamic element in attachData) {
      attach.add(Attachment.fromMap(element));
    }
    return Note(
      nodeID: map['node_id'] ?? '',
      projectID: map['project_id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      attachments: attach,
      assignedTo: List<String>.from(map['assigned_to'] ?? <String>[]),
      createdBy: map['created_by'] ?? '',
      createdTime: TimeFun.parseTime(map['created_time']),
      deadline: TimeFun.parseTime(map['deadline']),
      lastEditTime: TimeFun.parseTime(map['last_edit_time']),
    );
  }
}
