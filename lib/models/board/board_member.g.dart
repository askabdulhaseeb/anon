// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_member.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardMemberAdapter extends TypeAdapter<BoardMember> {
  @override
  final int typeId = 61;

  @override
  BoardMember read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoardMember(
      uid: fields[0] as String,
      isRequestPending: fields[3] as bool,
      invitationAccepted: fields[4] as bool,
      addedBy: fields[1] as String?,
      role: fields[2] as ChatMemberRole?,
      joiningDate: fields[5] as DateTime?,
      lastUpdate: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, BoardMember obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.addedBy)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.isRequestPending)
      ..writeByte(4)
      ..write(obj.invitationAccepted)
      ..writeByte(5)
      ..write(obj.joiningDate)
      ..writeByte(6)
      ..write(obj.lastUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardMemberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
