// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 3;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      pid: fields[0] as String,
      title: fields[1] as String,
      agencies: (fields[2] as List).cast<String>(),
      logo: fields[6] == null ? '' : fields[6] as String,
      description: fields[8] == null ? '' : fields[8] as String,
      milestone:
          fields[10] == null ? [] : (fields[10] as List?)?.cast<Milestone>(),
      members: (fields[3] as List?)?.cast<String>(),
      startingTime: fields[4] as DateTime?,
      endingTime: fields[5] as DateTime?,
      notes: fields[7] == null ? [] : (fields[7] as List?)?.cast<Note>(),
      createdBy: fields[9] == null ? '' : fields[9] as String?,
      defaultColor: fields[11] == null ? 808080 : fields[11] as int?,
      lastUpdate: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.pid)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.agencies)
      ..writeByte(3)
      ..write(obj.members)
      ..writeByte(4)
      ..write(obj.startingTime)
      ..writeByte(5)
      ..write(obj.endingTime)
      ..writeByte(6)
      ..write(obj.logo)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.createdBy)
      ..writeByte(10)
      ..write(obj.milestone)
      ..writeByte(11)
      ..write(obj.defaultColor)
      ..writeByte(12)
      ..write(obj.lastUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
