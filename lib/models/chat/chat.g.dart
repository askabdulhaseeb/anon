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
      imageURL: fields[8] == null ? '' : fields[8] as String,
      persons: (fields[1] as List).cast<String>(),
      projectID: fields[2] as String,
      members: (fields[4] as List).cast<ChatMember>(),
      title: fields[9] == null ? '' : fields[9] as String,
      description: fields[10] == null ? '' : fields[10] as String,
      lastMessage: fields[5] as Message?,
      defaultColor: fields[12] == null ? 808080 : fields[12] as int?,
      chatID: fields[0] as String?,
      chatNotes: (fields[3] as List?)?.cast<Note>(),
      unseenMessages: (fields[6] as List?)?.cast<Message>(),
      timestamp: fields[7] as DateTime?,
      lastUpdate: fields[13] as DateTime?,
      targetString: (fields[11] as List?)?.cast<TargetString>(),
    );
  }

  @override
  void write(BinaryWriter writer, Chat obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.timestamp)
      ..writeByte(8)
      ..write(obj.imageURL)
      ..writeByte(9)
      ..write(obj.title)
      ..writeByte(10)
      ..write(obj.description)
      ..writeByte(11)
      ..write(obj.targetString)
      ..writeByte(12)
      ..write(obj.defaultColor)
      ..writeByte(13)
      ..write(obj.lastUpdate);
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
