// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskCardAdapter extends TypeAdapter<TaskCard> {
  @override
  final int typeId = 63;

  @override
  TaskCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskCard(
      boardID: fields[1] as String,
      listID: fields[2] as String,
      position: fields[4] as int,
      title: fields[5] as String,
      description: fields[6] as String,
      projectID: fields[3] as String?,
      cardID: fields[0] as String?,
      attachments: (fields[7] as List?)?.cast<Attachment>(),
      assignTo: (fields[8] as List?)?.cast<String>(),
      checklists: (fields[9] as List?)?.cast<CheckList>(),
      createdBy: fields[10] as String?,
      createdDate: fields[11] as DateTime?,
      startDate: fields[12] as DateTime?,
      dueDate: fields[13] as DateTime?,
      lastFetch: fields[14] as DateTime?,
      lastUpdate: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TaskCard obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.cardID)
      ..writeByte(1)
      ..write(obj.boardID)
      ..writeByte(2)
      ..write(obj.listID)
      ..writeByte(3)
      ..write(obj.projectID)
      ..writeByte(4)
      ..write(obj.position)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.attachments)
      ..writeByte(8)
      ..write(obj.assignTo)
      ..writeByte(9)
      ..write(obj.checklists)
      ..writeByte(10)
      ..write(obj.createdBy)
      ..writeByte(11)
      ..write(obj.createdDate)
      ..writeByte(12)
      ..write(obj.startDate)
      ..writeByte(13)
      ..write(obj.dueDate)
      ..writeByte(14)
      ..write(obj.lastFetch)
      ..writeByte(15)
      ..write(obj.lastUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
