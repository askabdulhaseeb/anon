// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CheckItemAdapter extends TypeAdapter<CheckItem> {
  @override
  final int typeId = 65;

  @override
  CheckItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckItem(
      text: fields[2] as String,
      position: fields[1] as int,
      isChecked: fields[3] as bool,
      id: fields[0] as String?,
      createdBy: fields[4] as String?,
      createdDate: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CheckItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.position)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.isChecked)
      ..writeByte(4)
      ..write(obj.createdBy)
      ..writeByte(5)
      ..write(obj.createdDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
