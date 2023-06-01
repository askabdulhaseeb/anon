// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_token.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyDeviceTokenAdapter extends TypeAdapter<MyDeviceToken> {
  @override
  final int typeId = 15;

  @override
  MyDeviceToken read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyDeviceToken(
      token: fields[0] as String,
      failNotificationByUID: (fields[1] as List?)?.cast<String>(),
      registerTimestamp: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MyDeviceToken obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.token)
      ..writeByte(1)
      ..write(obj.failNotificationByUID)
      ..writeByte(2)
      ..write(obj.registerTimestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyDeviceTokenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
