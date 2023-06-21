// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MilestoneAdapter extends TypeAdapter<Milestone> {
  @override
  final int typeId = 34;

  @override
  Milestone read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Milestone(
      milestoneID: fields[0] as String,
      projectID: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String,
      deadline: fields[4] as DateTime,
      payment: fields[7] as double,
      completedTime: fields[6] as DateTime?,
      currency: fields[8] as String,
      startingTime: fields[5] as DateTime?,
      createdBy: fields[9] as String?,
      assignTo: (fields[10] as List?)?.cast<String>(),
      history: (fields[11] as List?)?.cast<MilestoneHistory>(),
      isCompleted: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Milestone obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.milestoneID)
      ..writeByte(1)
      ..write(obj.projectID)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.deadline)
      ..writeByte(5)
      ..write(obj.startingTime)
      ..writeByte(6)
      ..write(obj.completedTime)
      ..writeByte(7)
      ..write(obj.payment)
      ..writeByte(8)
      ..write(obj.currency)
      ..writeByte(9)
      ..write(obj.createdBy)
      ..writeByte(10)
      ..write(obj.assignTo)
      ..writeByte(11)
      ..write(obj.history)
      ..writeByte(12)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MilestoneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
