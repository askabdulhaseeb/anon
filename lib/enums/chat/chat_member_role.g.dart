// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_member_role.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatMemberRoleAdapter extends TypeAdapter<ChatMemberRole> {
  @override
  final int typeId = 410;

  @override
  ChatMemberRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChatMemberRole.admin;
      case 1:
        return ChatMemberRole.member;
      case 2:
        return ChatMemberRole.viewer;
      default:
        return ChatMemberRole.admin;
    }
  }

  @override
  void write(BinaryWriter writer, ChatMemberRole obj) {
    switch (obj) {
      case ChatMemberRole.admin:
        writer.writeByte(0);
        break;
      case ChatMemberRole.member:
        writer.writeByte(1);
        break;
      case ChatMemberRole.viewer:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMemberRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
