import '../../database/firebase/auth_methods.dart';
import '../../functions/time_functions.dart';
import '../../functions/unique_id_fun.dart';
import 'check_item.dart';

class CheckList {
  CheckList({
    required this.cardID,
    required this.title,
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

  final String checkListID;
  final String cardID;
  final String title;
  final List<CheckItem> items;
  final String createdBy;
  final DateTime createdDate;
  final DateTime lastFetch;
  final DateTime lastUpdate;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'check_list_id': checkListID,
      'card_id': cardID,
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
