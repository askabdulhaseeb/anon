import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'target_type.g.dart';

@HiveType(typeId: 47)
enum TargetType {
  @HiveField(0)
  easy('easy', 'Easy', Colors.orange),
  @HiveField(1)
  medium('medium', 'Medium', Colors.deepOrange),
  @HiveField(2)
  serious('serious', 'Serious', Colors.red);

  const TargetType(this.json, this.title, this.color);
  final String json;
  final String title;
  final Color color;
}

class TargetTypeConvertor {
  TargetType toEnum(String type) {
    switch (type) {
      case 'easy':
        return TargetType.easy;
      case 'medium':
        return TargetType.medium;
      case 'serious':
        return TargetType.serious;
      default:
        return TargetType.serious;
    }
  }
}
