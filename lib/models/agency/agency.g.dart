// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agency.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AgencyAdapter extends TypeAdapter<Agency> {
  @override
  final int typeId = 2;

  @override
  Agency read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Agency(
      agencyID: fields[0] as String,
      agencyCode: fields[3] as String,
      name: fields[1] as String,
      websiteURL: fields[4] as String?,
      logoURL: fields[9] as String?,
      members: (fields[5] as List?)?.cast<String>(),
      activeMembers: (fields[6] as List?)?.cast<MemberDetail>(),
      pendingRequest: (fields[7] as List?)?.cast<MemberDetail>(),
      requestHistory: (fields[8] as List?)?.cast<MemberDetail>(),
      isCurrenlySelected: fields[10] == null ? false : fields[10] as bool?,
      lastUpdate: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Agency obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.agencyID)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.agencyCode)
      ..writeByte(4)
      ..write(obj.websiteURL)
      ..writeByte(5)
      ..write(obj.members)
      ..writeByte(6)
      ..write(obj.activeMembers)
      ..writeByte(7)
      ..write(obj.pendingRequest)
      ..writeByte(8)
      ..write(obj.requestHistory)
      ..writeByte(9)
      ..write(obj.logoURL)
      ..writeByte(10)
      ..write(obj.isCurrenlySelected)
      ..writeByte(11)
      ..write(obj.lastUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
