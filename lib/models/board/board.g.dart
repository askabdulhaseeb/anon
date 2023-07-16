// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardAdapter extends TypeAdapter<Board> {
  @override
  final int typeId = 60;

  @override
  Board read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Board(
      title: fields[1] as String,
      persons: (fields[3] as List).cast<String>(),
      members: (fields[4] as List).cast<BoardMember>(),
      projectID: fields[2] as String?,
      boardID: fields[0] as String?,
      createdBy: fields[5] as String?,
      createdDate: fields[6] as DateTime?,
      lastFetch: fields[7] as DateTime?,
      lastUpdate: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Board obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.boardID)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.projectID)
      ..writeByte(3)
      ..write(obj.persons)
      ..writeByte(4)
      ..write(obj.members)
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
      other is BoardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
