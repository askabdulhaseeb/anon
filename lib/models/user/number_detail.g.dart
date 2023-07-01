// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'number_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NumberDetailsAdapter extends TypeAdapter<NumberDetails> {
  @override
  final int typeId = 14;

  @override
  NumberDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NumberDetails(
      countryCode: fields[0] as String?,
      number: fields[1] as String?,
      completeNumber: fields[2] as String?,
      isoCode: fields[3] as String?,
      timestamp: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, NumberDetails obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.countryCode)
      ..writeByte(1)
      ..write(obj.number)
      ..writeByte(2)
      ..write(obj.completeNumber)
      ..writeByte(3)
      ..write(obj.isoCode)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumberDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
