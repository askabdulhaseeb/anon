import '../../database/firebase/auth_methods.dart';
import '../../functions/time_functions.dart';
import '../../functions/unique_id_fun.dart';

class TaskList {
  TaskList({
    required this.boardID,
    required this.title,
    String? listID,
    this.projectID,
    String? createdBy,
    DateTime? createdDate,
    DateTime? lastFetch,
    DateTime? lastUpdate,
  })  : listID = listID ?? UniqueIdFun.listID(boardID),
        createdBy = createdBy ?? AuthMethods.uid,
        createdDate = createdDate ?? DateTime.now(),
        lastFetch = lastFetch ?? DateTime.now(),
        lastUpdate = lastUpdate ?? DateTime.now();

  final String boardID;
  final String? projectID;
  final String listID;
  final String title;
  final String createdBy;
  final DateTime createdDate;
  final DateTime lastFetch;
  final DateTime lastUpdate;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'board_id': boardID,
      'project_id': projectID,
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
      listID: map['list_id'] ?? '',
      title: map['title'] ?? '',
      createdBy: map['created_by'] ?? '',
      createdDate: TimeFun.parseTime(map['created_date']),
      lastFetch: DateTime.now(),
      lastUpdate: TimeFun.parseTime(map['last_update']),
    );
  }
}
