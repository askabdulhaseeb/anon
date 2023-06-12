// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_member_role.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatMemberRoleAdapter extends TypeAdapter<ChatMemberRole> {
  @override
  final int typeId = 43;

  @override
  ChatMemberRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 3:
        return ChatMemberRole.admin;
      case 4:
        return ChatMemberRole.member;
      case 5:
        return ChatMemberRole.viewer;
      default:
        return ChatMemberRole.admin;
    }
  }

  @override
  void write(BinaryWriter writer, ChatMemberRole obj) {
    switch (obj) {
      case ChatMemberRole.admin:
        writer.writeByte(3);
        break;
      case ChatMemberRole.member:
        writer.writeByte(4);
        break;
      case ChatMemberRole.viewer:
        writer.writeByte(5);
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
