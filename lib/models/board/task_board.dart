import '../../database/firebase/auth_methods.dart';
import '../../functions/time_functions.dart';
import '../../functions/unique_id_fun.dart';

class Board {
  Board({
    required this.title,
    required this.persons,
    this.projectID,
    String? boardID,
    String? createdBy,
    DateTime? createdDate,
    DateTime? lastFetch,
    DateTime? lastUpdate,
  })  : boardID = boardID ?? UniqueIdFun.boardID(),
        createdBy = createdBy ?? AuthMethods.uid,
        createdDate = createdDate ?? DateTime.now(),
        lastFetch = lastFetch ?? DateTime.now(),
        lastUpdate = lastUpdate ?? DateTime.now();

  final String boardID;
  final String title;
  final String? projectID;
  final List<String> persons;
  // final List<String> members;
  final String createdBy;
  final DateTime createdDate;
  final DateTime lastFetch;
  final DateTime lastUpdate;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'board_id': boardID,
      'title': title,
      'project_id': projectID,
      'persons': persons,
      'created_by': createdBy,
      'created_date': createdDate,
      'last_update': lastUpdate,
    };
  }

  // ignore: sort_constructors_first
  factory Board.fromMap(Map<String, dynamic> map) {
    return Board(
      boardID: map['board_id'] ?? '',
      title: map['title'] ?? '',
      projectID: map['project_id'],
      persons:
          List<String>.from((map['persons'] ?? <String>[]) as List<String>),
      createdBy: map['created_by'] ?? '',
      createdDate: TimeFun.parseTime(map['created_date']),
      lastFetch: DateTime.now(),
      lastUpdate: TimeFun.parseTime(map['last_update']),
    );
  }
}
