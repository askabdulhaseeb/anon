import 'package:hive/hive.dart';

import '../../database/firebase/auth_methods.dart';
import '../../functions/time_functions.dart';
part 'check_item.g.dart';

@HiveType(typeId: 65)
class CheckItem {
  CheckItem({
    required this.text,
    required this.position,
    this.isChecked = false,
    String? id,
    String? createdBy,
    DateTime? createdDate,
  })  : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        createdBy = createdBy ?? AuthMethods.uid,
        createdDate = createdDate ?? DateTime.now();

  @HiveField(0)
  final String id;
  @HiveField(1)
  int position;
  @HiveField(2)
  String text;
  @HiveField(3)
  bool isChecked;
  @HiveField(4)
  final String createdBy;
  @HiveField(5)
  final DateTime createdDate;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'position': position,
      'text': text,
      'is_checked': isChecked,
      'created_by': createdBy,
      'created_date': createdDate,
    };
  }

  // ignore: sort_constructors_first
  factory CheckItem.fromMap(Map<String, dynamic> map) {
    return CheckItem(
      id: map['id'] ?? '',
      position: map['position'] ?? 0,
      text: map['text'] ?? '',
      isChecked: map['is_checked'] ?? false,
      createdBy: map['created_by'] ?? '',
      createdDate: TimeFun.parseTime(map['created_date']),
    );
  }
}
