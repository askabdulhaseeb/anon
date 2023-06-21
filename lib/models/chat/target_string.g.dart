// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_string.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TargetStringAdapter extends TypeAdapter<TargetString> {
  @override
  final int typeId = 46;

  @override
  TargetString read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TargetString(
      target: fields[0] as String,
      type: fields[1] as TargetType,
    );
  }

  @override
  void write(BinaryWriter writer, TargetString obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.target)
      ..writeByte(1)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TargetStringAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
