// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unseen_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnseenMessageAdapter extends TypeAdapter<UnseenMessage> {
  @override
  final int typeId = 46;

  @override
  UnseenMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnseenMessage(
      projectID: fields[0] as String,
      chatID: fields[1] as String,
      lastMessageAdded: fields[2] as DateTime,
      unseenMessages: (fields[3] as List).cast<Message>(),
    );
  }

  @override
  void write(BinaryWriter writer, UnseenMessage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.projectID)
      ..writeByte(1)
      ..write(obj.chatID)
      ..writeByte(2)
      ..write(obj.lastMessageAdded)
      ..writeByte(3)
      ..write(obj.unseenMessages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnseenMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
