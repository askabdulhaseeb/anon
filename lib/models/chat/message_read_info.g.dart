// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_read_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageReadInfoAdapter extends TypeAdapter<MessageReadInfo> {
  @override
  final int typeId = 45;

  @override
  MessageReadInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageReadInfo(
      uid: fields[0] as String,
      delivered: fields[1] as bool,
      seen: fields[2] as bool,
      deliveryAt: fields[3] as DateTime?,
      seenAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MessageReadInfo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.delivered)
      ..writeByte(2)
      ..write(obj.seen)
      ..writeByte(3)
      ..write(obj.deliveryAt)
      ..writeByte(4)
      ..write(obj.seenAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageReadInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
