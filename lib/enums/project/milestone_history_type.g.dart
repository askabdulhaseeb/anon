// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone_history_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MilestoneHistoryTypeAdapter extends TypeAdapter<MilestoneHistoryType> {
  @override
  final int typeId = 36;

  @override
  MilestoneHistoryType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MilestoneHistoryType.start;
      case 1:
        return MilestoneHistoryType.update;
      case 2:
        return MilestoneHistoryType.submit;
      case 3:
        return MilestoneHistoryType.revision;
      case 4:
        return MilestoneHistoryType.complete;
      case 5:
        return MilestoneHistoryType.cancel;
      default:
        return MilestoneHistoryType.start;
    }
  }

  @override
  void write(BinaryWriter writer, MilestoneHistoryType obj) {
    switch (obj) {
      case MilestoneHistoryType.start:
        writer.writeByte(0);
        break;
      case MilestoneHistoryType.update:
        writer.writeByte(1);
        break;
      case MilestoneHistoryType.submit:
        writer.writeByte(2);
        break;
      case MilestoneHistoryType.revision:
        writer.writeByte(3);
        break;
      case MilestoneHistoryType.complete:
        writer.writeByte(4);
        break;
      case MilestoneHistoryType.cancel:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MilestoneHistoryTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
