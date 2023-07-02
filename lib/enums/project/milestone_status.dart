import 'package:hive_flutter/hive_flutter.dart';
part 'milestone_status.g.dart';

@HiveType(typeId: 37)
enum MilestoneStatus {
  @HiveField(0)
  inActive('in_active', 'In Active'),
  @HiveField(1)
  active('active', 'Active'),
  @HiveField(2)
  done('done', 'Done'),
  @HiveField(3)
  cancel('cancel', 'Cancel');

  const MilestoneStatus(this.json, this.title);
  final String json;
  final String title;
}

class MilestoneStatusConvertor {
  MilestoneStatus toEnum(String status) {
    switch (status) {
      case 'in_active':
        return MilestoneStatus.inActive;
      case 'active':
        return MilestoneStatus.active;
      case 'done':
        return MilestoneStatus.done;
      case 'cancel':
        return MilestoneStatus.cancel;
      default:
        return MilestoneStatus.inActive;
    }
  }
}
