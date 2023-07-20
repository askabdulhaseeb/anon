import 'package:cloud_firestore/cloud_firestore.dart';
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
    required this.projectID,
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
  String title;
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
  DateTime lastFetch;
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
  factory Board.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Board(
      boardID: doc.data()?['board_id'] ?? '',
      title: doc.data()?['title'] ?? '',
      projectID: doc.data()?['project_id'],
      persons: List<String>.from(doc.data()?['persons'] ?? <String>[]),
      members: List<BoardMember>.from(
        (doc.data()?['members'] ?? <dynamic>[]).map<BoardMember>(
          (dynamic x) => BoardMember.fromMap(x as Map<String, dynamic>),
        ),
      ),
      createdBy: doc.data()?['created_by'] ?? '',
      createdDate: TimeFun.parseTime(doc.data()?['created_date']),
      lastFetch: DateTime.now(),
      lastUpdate: TimeFun.parseTime(doc.data()?['last_update']),
    );
  }
}
