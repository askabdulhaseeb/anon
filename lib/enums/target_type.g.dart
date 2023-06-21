// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TargetTypeAdapter extends TypeAdapter<TargetType> {
  @override
  final int typeId = 47;

  @override
  TargetType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TargetType.easy;
      case 1:
        return TargetType.medium;
      case 2:
        return TargetType.serious;
      default:
        return TargetType.easy;
    }
  }

  @override
  void write(BinaryWriter writer, TargetType obj) {
    switch (obj) {
      case TargetType.easy:
        writer.writeByte(0);
        break;
      case TargetType.medium:
        writer.writeByte(1);
        break;
      case TargetType.serious:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TargetTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
