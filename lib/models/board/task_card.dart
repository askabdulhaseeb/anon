import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../../database/firebase/auth_methods.dart';
import '../../functions/time_functions.dart';
import '../../functions/unique_id_fun.dart';
import '../project/attachment.dart';
import 'check_list.dart';
part 'task_card.g.dart';

@HiveType(typeId: 63)
class TaskCard extends HiveObject {
  TaskCard({
    required this.boardID,
    required this.listID,
    required this.position,
    required this.title,
    this.description = '',
    this.projectID,
    String? cardID,
    this.coverURL,
    List<Attachment>? attachments,
    List<String>? assignTo,
    List<CheckList>? checklists,
    String? createdBy,
    DateTime? createdDate,
    DateTime? startDate,
    DateTime? dueDate,
    DateTime? lastFetch,
    DateTime? lastUpdate,
  })  : cardID = cardID ?? UniqueIdFun.unique(),
        attachments = attachments ?? <Attachment>[],
        assignTo = assignTo ?? <String>[],
        checklists = checklists ?? <CheckList>[],
        createdBy = createdBy ?? AuthMethods.uid,
        createdDate = createdDate ?? DateTime.now(),
        startDate = startDate ?? DateTime.now(),
        dueDate = dueDate ?? DateTime.now(),
        lastFetch = lastFetch ?? DateTime.now(),
        lastUpdate = lastUpdate ?? DateTime.now();

  @HiveField(0)
  final String cardID;
  @HiveField(1)
  final String boardID;
  @HiveField(2)
  String listID;
  @HiveField(3)
  final String? projectID;
  @HiveField(4)
  int position;
  @HiveField(5)
  String title;
  @HiveField(6)
  String description;
  @HiveField(7)
  final List<Attachment> attachments;
  @HiveField(8)
  final List<String> assignTo;
  @HiveField(9)
  final List<CheckList> checklists;
  @HiveField(10)
  final String createdBy;
  @HiveField(11)
  final DateTime createdDate;
  @HiveField(12)
  DateTime startDate;
  @HiveField(13)
  DateTime dueDate;
  @HiveField(14)
  DateTime lastFetch;
  @HiveField(15)
  DateTime lastUpdate; //
  @HiveField(16)
  String? coverURL;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'card_id': cardID,
      'board_id': boardID,
      'list_id': listID,
      'project_id': projectID,
      'position': position,
      'title': title,
      'description': description,
      'cover_url': coverURL,
      'attachments': attachments.map((Attachment x) => x.toMap()).toList(),
      'assign_to': assignTo,
      'checklists': checklists.map((CheckList x) => x.toMap()).toList(),
      'created_by': createdBy,
      'created_date': createdDate,
      'start_date': startDate,
      'due_date': dueDate,
      'last_update': lastUpdate,
    };
  }

  Map<String, dynamic> updateMap() {
    return <String, dynamic>{
      'position': position,
      'title': title,
      'description': description,
      'cover_url': coverURL,
      'attachments': attachments.map((Attachment x) => x.toMap()).toList(),
      'assign_to': assignTo,
      'checklists': checklists.map((CheckList x) => x.toMap()).toList(),
      'start_date': startDate,
      'due_date': dueDate,
      'last_update': lastUpdate = DateTime.now(),
    };
  }

  // ignore: sort_constructors_first
  factory TaskCard.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return TaskCard(
      cardID: doc.data()?['card_id'] ?? '',
      boardID: doc.data()?['board_id'] ?? '',
      listID: doc.data()?['list_id'] ?? '',
      projectID: doc.data()?['project_id'] ?? '',
      position: doc.data()?['position'] as int,
      title: doc.data()?['title'] ?? '',
      description: doc.data()?['description'] ?? '',
      assignTo: List<String>.from(doc.data()?['assign_to'] ?? <String>[]),
      coverURL: doc.data()?['cover_url'] ?? '',
      attachments: List<Attachment>.from(
        (doc.data()?['attachments'] as List<dynamic>).map<Attachment>(
          (dynamic x) => Attachment.fromMap(x as Map<String, dynamic>),
        ),
      ),
      checklists: List<CheckList>.from(
        (doc.data()?['checklists'] as List<dynamic>).map<CheckList>(
          (dynamic x) => CheckList.fromMap(x as Map<String, dynamic>),
        ),
      ),
      createdBy: doc.data()?['created_by'] ?? '',
      createdDate: TimeFun.parseTime(doc.data()?['created_date']),
      startDate: TimeFun.parseTime(doc.data()?['start_date']),
      dueDate: TimeFun.parseTime(doc.data()?['due_date']),
      lastFetch: DateTime.now(),
      lastUpdate: TimeFun.parseTime(doc.data()?['last_update']),
    );
  }
}
