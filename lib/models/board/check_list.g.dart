// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CheckListAdapter extends TypeAdapter<CheckList> {
  @override
  final int typeId = 64;

  @override
  CheckList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckList(
      cardID: fields[1] as String,
      title: fields[2] as String,
      position: fields[3] as int,
      checkListID: fields[0] as String?,
      items: (fields[4] as List?)?.cast<CheckItem>(),
      createdBy: fields[5] as String?,
      createdDate: fields[6] as DateTime?,
      lastFetch: fields[7] as DateTime?,
      lastUpdate: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CheckList obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.checkListID)
      ..writeByte(1)
      ..write(obj.cardID)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.items)
      ..writeByte(5)
      ..write(obj.createdBy)
      ..writeByte(6)
      ..write(obj.createdDate)
      ..writeByte(7)
      ..write(obj.lastFetch)
      ..writeByte(8)
      ..write(obj.lastUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
