import 'package:hive/hive.dart';

import '../../database/firebase/auth_methods.dart';
import '../../functions/time_functions.dart';
import '../../functions/unique_id_fun.dart';
import 'check_item.dart';
part 'check_list.g.dart';

@HiveType(typeId: 64)
class CheckList extends HiveObject {
  CheckList({
    required this.cardID,
    required this.title,
    required this.position,
    String? checkListID,
    List<CheckItem>? items,
    String? createdBy,
    DateTime? createdDate,
    DateTime? lastFetch,
    DateTime? lastUpdate,
  })  : checkListID = checkListID ?? UniqueIdFun.unique(),
        items = items ?? <CheckItem>[],
        createdBy = createdBy ?? AuthMethods.uid,
        createdDate = createdDate ?? DateTime.now(),
        lastFetch = lastFetch ?? DateTime.now(),
        lastUpdate = lastUpdate ?? DateTime.now();

  @HiveField(0)
  final String checkListID;
  @HiveField(1)
  final String cardID;
  @HiveField(2)
  String title;
  @HiveField(3)
  int position;
  @HiveField(4)
  final List<CheckItem> items;
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
      'check_list_id': checkListID,
      'card_id': cardID,
      'position': position,
      'title': title,
      'items': items.map((CheckItem x) => x.toMap()).toList(),
      'created_by': createdBy,
      'created_date': createdDate,
      'last_update': lastUpdate,
    };
  }

  // ignore: sort_constructors_first
  factory CheckList.fromMap(Map<String, dynamic> map) {
    return CheckList(
      checkListID: map['check_list_id'] ?? '',
      cardID: map['card_id'] ?? '',
      position: map['position'] ?? 0,
      title: map['title'] ?? '',
      items: List<CheckItem>.from(
        (map['items'] as List<dynamic>).map<CheckItem>(
          (dynamic x) => CheckItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      createdBy: map['created_by'] ?? '',
      createdDate: TimeFun.parseTime(map['created_date']),
      lastFetch: DateTime.now(),
      lastUpdate: TimeFun.parseTime(map['last_update']),
    );
  }
}
