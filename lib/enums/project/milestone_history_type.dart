import 'package:hive_flutter/hive_flutter.dart';
part 'milestone_history_type.g.dart';

@HiveType(typeId: 36)
enum MilestoneHistoryType {
  @HiveField(0)
  start('start', 'Start'),
  @HiveField(1)
  update('update', 'Update'),
  @HiveField(2)
  submit('submit', 'Submit'),
  @HiveField(3)
  revision('revision', 'Revision'),
  @HiveField(4)
  complete('complete', 'Complete'),
  @HiveField(5)
  cancel('cancel', 'Cancel');

  const MilestoneHistoryType(this.json, this.title);

  final String json;
  final String title;
}

class MilestoneHistoryTypeConvertor {
  MilestoneHistoryType toEnum(String type) {
    switch (type) {
      case 'start':
        return MilestoneHistoryType.start;
      case 'update':
        return MilestoneHistoryType.update;
      case 'submit':
        return MilestoneHistoryType.submit;
      case 'revision':
        return MilestoneHistoryType.revision;
      case 'complete':
        return MilestoneHistoryType.complete;
      case 'cancel':
        return MilestoneHistoryType.cancel;
      default:
        return MilestoneHistoryType.cancel;
    }
  }
}
