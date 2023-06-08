// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_group_member.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatMemberAdapter extends TypeAdapter<ChatMember> {
  @override
  final int typeId = 41;

  @override
  ChatMember read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMember(
      uid: fields[0] as String,
      role: fields[1] as ChatMemberRole?,
      addedBy: fields[2] as String?,
      invitationAccepted: fields[3] as bool?,
      memberSince: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMember obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.addedBy)
      ..writeByte(3)
      ..write(obj.invitationAccepted)
      ..writeByte(4)
      ..write(obj.memberSince);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMemberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
