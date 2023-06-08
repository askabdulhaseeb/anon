// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatAdapter extends TypeAdapter<Chat> {
  @override
  final int typeId = 4;

  @override
  Chat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chat(
      persons: (fields[1] as List).cast<String>(),
      projectID: fields[2] as String,
      members: (fields[4] as List).cast<ChatMember>(),
      lastMessage: fields[5] as Message?,
      chatID: fields[0] as String?,
      chatNotes: (fields[3] as List?)?.cast<Note>(),
      unseenMessages: (fields[6] as List?)?.cast<Message>(),
      timestamp: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Chat obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.chatID)
      ..writeByte(1)
      ..write(obj.persons)
      ..writeByte(2)
      ..write(obj.projectID)
      ..writeByte(3)
      ..write(obj.chatNotes)
      ..writeByte(4)
      ..write(obj.members)
      ..writeByte(5)
      ..write(obj.lastMessage)
      ..writeByte(6)
      ..write(obj.unseenMessages)
      ..writeByte(7)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
