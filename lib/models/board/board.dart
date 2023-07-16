import 'package:hive/hive.dart';

import '../../database/firebase/auth_methods.dart';
import '../../functions/time_functions.dart';
import '../../functions/unique_id_fun.dart';
import 'board_member.dart';
part 'board.g.dart';

@HiveType(typeId: 60)
class Board extends HiveObject {
  Board({
    required this.title,
    required this.persons,
    required this.members,
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

  @HiveField(0)
  final String boardID;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String? projectID;
  @HiveField(3)
  final List<String> persons;
  @HiveField(4)
  final List<BoardMember> members;
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
      'title': title,
      'project_id': projectID,
      'persons': persons,
      'members': members.map((BoardMember e) => e.toMap()).toList(),
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
      members: List<BoardMember>.from(
        (map['member'] as List<dynamic>).map<BoardMember>(
          (dynamic x) => BoardMember.fromMap(x as Map<String, dynamic>),
        ),
      ),
      createdBy: map['created_by'] ?? '',
      createdDate: TimeFun.parseTime(map['created_date']),
      lastFetch: DateTime.now(),
      lastUpdate: TimeFun.parseTime(map['last_update']),
    );
  }
}
