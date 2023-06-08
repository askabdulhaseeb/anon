// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 42;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      text: fields[1] as String?,
      type: fields[3] as MessageType,
      displayString: fields[2] as String,
      attachment: (fields[4] as List).cast<Attachment>(),
      sendTo: (fields[7] as List).cast<MessageReadInfo>(),
      sendToUIDs: (fields[8] as List).cast<String>(),
      messageID: fields[0] as String?,
      timestamp: fields[9] as DateTime?,
      sendBy: fields[5] as String?,
      replyOf: fields[10] as Message?,
      isLive: fields[11] as bool,
      refID: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.messageID)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.displayString)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.attachment)
      ..writeByte(5)
      ..write(obj.sendBy)
      ..writeByte(6)
      ..write(obj.refID)
      ..writeByte(7)
      ..write(obj.sendTo)
      ..writeByte(8)
      ..write(obj.sendToUIDs)
      ..writeByte(9)
      ..write(obj.timestamp)
      ..writeByte(10)
      ..write(obj.replyOf)
      ..writeByte(11)
      ..write(obj.isLive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
