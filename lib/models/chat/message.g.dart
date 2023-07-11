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
      chatID: fields[12] == null ? '' : fields[12] as String,
      projectID: fields[14] == null ? '' : fields[14] as String,
      type: fields[3] as MessageType,
      attachment: (fields[4] as List).cast<Attachment>(),
      sendTo: (fields[7] as List).cast<MessageReadInfo>(),
      sendToUIDs: (fields[8] as List).cast<String>(),
      text: fields[1] as String,
      displayString: fields[2] as String,
      messageID: fields[0] as String?,
      timestamp: fields[9] as DateTime?,
      lastUpdate: fields[16] as DateTime?,
      sendBy: fields[5] as String?,
      replyOf: fields[10] as Message?,
      isLive: fields[11] as bool,
      isEncrypted: fields[13] == null ? true : fields[13] as bool,
      isBuged: fields[15] == null ? false : fields[15] as bool,
      hasError: fields[17] == null ? false : fields[17] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(17)
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
      ..writeByte(7)
      ..write(obj.sendTo)
      ..writeByte(8)
      ..write(obj.sendToUIDs)
      ..writeByte(9)
      ..write(obj.timestamp)
      ..writeByte(10)
      ..write(obj.replyOf)
      ..writeByte(11)
      ..write(obj.isLive)
      ..writeByte(12)
      ..write(obj.chatID)
      ..writeByte(13)
      ..write(obj.isEncrypted)
      ..writeByte(14)
      ..write(obj.projectID)
      ..writeByte(15)
      ..write(obj.isBuged)
      ..writeByte(16)
      ..write(obj.lastUpdate)
      ..writeByte(17)
      ..write(obj.hasError);
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
