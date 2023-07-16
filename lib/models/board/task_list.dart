import 'package:hive/hive.dart';

import '../../database/firebase/auth_methods.dart';
import '../../functions/time_functions.dart';
import '../../functions/unique_id_fun.dart';
part 'task_list.g.dart';

@HiveType(typeId: 62)
class TaskList extends HiveObject {
  TaskList({
    required this.boardID,
    required this.title,
    required this.position,
    this.projectID,
    String? listID,
    String? createdBy,
    DateTime? createdDate,
    DateTime? lastFetch,
    DateTime? lastUpdate,
  })  : listID = listID ?? UniqueIdFun.listID(boardID),
        createdBy = createdBy ?? AuthMethods.uid,
        createdDate = createdDate ?? DateTime.now(),
        lastFetch = lastFetch ?? DateTime.now(),
        lastUpdate = lastUpdate ?? DateTime.now();

  @HiveField(0)
  final String boardID;
  @HiveField(1)
  final String? projectID;
  @HiveField(2)
  final int position;
  @HiveField(3)
  final String listID;
  @HiveField(4)
  final String title;
  @HiveField(5)
  final String createdBy;
  @HiveField(6)
  final DateTime createdDate;
  @HiveField(7)
  final DateTime lastFetch;
  @HiveField(8)
  final DateTime lastUpdate;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'board_id': boardID,
      'project_id': projectID,
      'position': position,
      'list_id': listID,
      'title': title,
      'created_by': createdBy,
      'created_date': createdDate,
      'last_update': lastUpdate,
    };
  }

  // ignore: sort_constructors_first
  factory TaskList.fromMap(Map<String, dynamic> map) {
    return TaskList(
      boardID: map['board_id'] ?? '',
      projectID: map['project_id'] ?? '',
      position: map['position'] ?? 0,
      listID: map['list_id'] ?? '',
      title: map['title'] ?? '',
      createdBy: map['created_by'] ?? '',
      createdDate: TimeFun.parseTime(map['created_date']),
      lastFetch: DateTime.now(),
      lastUpdate: TimeFun.parseTime(map['last_update']),
    );
  }
}
