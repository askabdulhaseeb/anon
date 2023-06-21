import 'package:hive/hive.dart';

import '../../enums/target_type.dart';
part 'target_string.g.dart';

@HiveType(typeId: 46)
class TargetString {
  TargetString({required this.target, required this.type});
  @HiveField(0)
  String target;
  @HiveField(1)
  TargetType type;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'target': target,
      'type': type.json,
    };
  }

  // ignore: sort_constructors_first
  factory TargetString.fromMap(Map<String, dynamic> map) {
    return TargetString(
      target: map['target'] ?? '',
      type: TargetTypeConvertor().toEnum(map['type'] ?? TargetType.easy),
    );
  }
}
