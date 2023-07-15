import '../../database/firebase/auth_methods.dart';
import '../../functions/time_functions.dart';

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

  final String id;
  final int position;
  final String text;
  final bool isChecked;
  final String createdBy;
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
