// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 31;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      projectID: fields[1] as String,
      description: fields[3] as String,
      title: fields[2] as String,
      attachments: (fields[4] as List).cast<Attachment>(),
      assignedTo: (fields[5] as List).cast<String>(),
      nodeID: fields[0] as String?,
      createdBy: fields[6] as String?,
      createdTime: fields[7] as DateTime?,
      deadline: fields[8] as DateTime?,
      lastEditTime: fields[9] as DateTime?,
      hasPublicAccess: fields[10] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.nodeID)
      ..writeByte(1)
      ..write(obj.projectID)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.attachments)
      ..writeByte(5)
      ..write(obj.assignedTo)
      ..writeByte(6)
      ..write(obj.createdBy)
      ..writeByte(7)
      ..write(obj.createdTime)
      ..writeByte(8)
      ..write(obj.deadline)
      ..writeByte(9)
      ..write(obj.lastEditTime)
      ..writeByte(10)
      ..write(obj.hasPublicAccess);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
