// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskListAdapter extends TypeAdapter<TaskList> {
  @override
  final int typeId = 62;

  @override
  TaskList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskList(
      boardID: fields[0] as String,
      title: fields[4] as String,
      position: fields[2] as int,
      projectID: fields[1] as String?,
      listID: fields[3] as String?,
      createdBy: fields[5] as String?,
      createdDate: fields[6] as DateTime?,
      lastFetch: fields[7] as DateTime?,
      lastUpdate: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TaskList obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.boardID)
      ..writeByte(1)
      ..write(obj.projectID)
      ..writeByte(2)
      ..write(obj.position)
      ..writeByte(3)
      ..write(obj.listID)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.createdBy)
      ..writeByte(6)
      ..write(obj.createdDate)
      ..writeByte(7)
      ..write(obj.lastFetch)
      ..writeByte(8)
      ..write(obj.lastUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
