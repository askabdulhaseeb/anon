// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_designation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDesignationAdapter extends TypeAdapter<UserDesignation> {
  @override
  final int typeId = 200;

  @override
  UserDesignation read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserDesignation.admin;
      case 1:
        return UserDesignation.manager;
      case 2:
        return UserDesignation.developer;
      case 3:
        return UserDesignation.employee;
      default:
        return UserDesignation.admin;
    }
  }

  @override
  void write(BinaryWriter writer, UserDesignation obj) {
    switch (obj) {
      case UserDesignation.admin:
        writer.writeByte(0);
        break;
      case UserDesignation.manager:
        writer.writeByte(1);
        break;
      case UserDesignation.developer:
        writer.writeByte(2);
        break;
      case UserDesignation.employee:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDesignationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
