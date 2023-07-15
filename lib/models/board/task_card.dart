import '../../database/firebase/auth_methods.dart';
import '../../functions/time_functions.dart';
import '../../functions/unique_id_fun.dart';
import '../project/attachment.dart';
import 'check_list.dart';

class TaskCard {
  TaskCard({
    required this.boardID,
    required this.listID,
    required this.position,
    required this.title,
    this.description = '',
    this.projectID,
    String? cardID,
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

  final String cardID;
  final String boardID;
  final String listID;
  final String? projectID;
  final int position;
  final String title;
  final String description;
  final List<Attachment> attachments;
  final List<String> assignTo;
  final List<CheckList> checklists;
  final String createdBy;
  final DateTime createdDate;
  final DateTime startDate;
  final DateTime dueDate;
  final DateTime lastFetch;
  final DateTime lastUpdate;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'card_id': cardID,
      'board_id': boardID,
      'list_id': listID,
      'project_id': projectID,
      'position': position,
      'title': title,
      'description': description,
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

  // ignore: sort_constructors_first
  factory TaskCard.fromMap(Map<String, dynamic> map) {
    return TaskCard(
      cardID: map['card_id'] as String,
      boardID: map['board_id'] as String,
      listID: map['list_id'] as String,
      projectID: map['project_id'] as String,
      position: map['position'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      assignTo: List<String>.from(map['assign_to'] as List<String>),
      attachments: List<Attachment>.from(
        (map['attachments'] as List<dynamic>).map<Attachment>(
          (dynamic x) => Attachment.fromMap(x as Map<String, dynamic>),
        ),
      ),
      checklists: List<CheckList>.from(
        (map['checklists'] as List<dynamic>).map<CheckList>(
          (dynamic x) => CheckList.fromMap(x as Map<String, dynamic>),
        ),
      ),
      createdBy: map['created_by'] as String,
      createdDate: TimeFun.parseTime(map['created_date']),
      startDate: TimeFun.parseTime(map['start_date']),
      dueDate: TimeFun.parseTime(map['due_date']),
      lastFetch: DateTime.now(),
      lastUpdate: TimeFun.parseTime(map['last_update']),
    );
  }
}
