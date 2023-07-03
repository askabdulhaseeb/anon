import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'milestone_status.g.dart';

@HiveType(typeId: 37)
enum MilestoneStatus {
  @HiveField(0)
  inActive('in_active', 'In Active', Colors.grey),
  @HiveField(1)
  active('active', 'Active', Colors.blue),
  @HiveField(2)
  done('done', 'Done', Colors.green),
  @HiveField(3)
  cancel('cancel', 'Cancel', Colors.red);

  const MilestoneStatus(this.json, this.title, this.color);
  final String json;
  final String title;
  final Color color;
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

  List<MilestoneStatus> availableOption(MilestoneStatus currentStatus) {
    switch (currentStatus) {
      case MilestoneStatus.inActive:
        return <MilestoneStatus>[
          MilestoneStatus.active,
          MilestoneStatus.cancel,
        ];
      case MilestoneStatus.active:
        return <MilestoneStatus>[
          MilestoneStatus.inActive,
          MilestoneStatus.done,
          MilestoneStatus.cancel,
        ];
      case MilestoneStatus.done:
        return <MilestoneStatus>[];
      case MilestoneStatus.cancel:
        return <MilestoneStatus>[MilestoneStatus.active];
      default:
        return <MilestoneStatus>[];
    }
  }
}
