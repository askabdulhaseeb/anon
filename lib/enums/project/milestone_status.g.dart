// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MilestoneStatusAdapter extends TypeAdapter<MilestoneStatus> {
  @override
  final int typeId = 37;

  @override
  MilestoneStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MilestoneStatus.inActive;
      case 1:
        return MilestoneStatus.active;
      case 2:
        return MilestoneStatus.done;
      case 3:
        return MilestoneStatus.cancel;
      default:
        return MilestoneStatus.inActive;
    }
  }

  @override
  void write(BinaryWriter writer, MilestoneStatus obj) {
    switch (obj) {
      case MilestoneStatus.inActive:
        writer.writeByte(0);
        break;
      case MilestoneStatus.active:
        writer.writeByte(1);
        break;
      case MilestoneStatus.done:
        writer.writeByte(2);
        break;
      case MilestoneStatus.cancel:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MilestoneStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
