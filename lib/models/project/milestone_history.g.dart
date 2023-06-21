// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MilestoneHistoryAdapter extends TypeAdapter<MilestoneHistory> {
  @override
  final int typeId = 35;

  @override
  MilestoneHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MilestoneHistory(
      type: fields[1] as MilestoneHistoryType,
      actionTime: fields[0] as DateTime?,
      actionBy: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MilestoneHistory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.actionTime)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.actionBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MilestoneHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
