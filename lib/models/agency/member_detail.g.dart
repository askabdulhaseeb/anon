// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemberDetailAdapter extends TypeAdapter<MemberDetail> {
  @override
  final int typeId = 20;

  @override
  MemberDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemberDetail(
      uid: fields[0] as String,
      designation: fields[7] as UserDesignation,
      isAccepted: fields[1] as bool?,
      isPending: fields[2] as bool?,
      responcedBy: fields[3] as String?,
      requestTime: fields[4] as DateTime?,
      responceTime: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MemberDetail obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.isAccepted)
      ..writeByte(2)
      ..write(obj.isPending)
      ..writeByte(3)
      ..write(obj.responcedBy)
      ..writeByte(4)
      ..write(obj.requestTime)
      ..writeByte(5)
      ..write(obj.responceTime)
      ..writeByte(7)
      ..write(obj.designation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
