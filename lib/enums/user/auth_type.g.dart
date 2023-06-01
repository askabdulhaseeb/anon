// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthTypeAdapter extends TypeAdapter<AuthType> {
  @override
  final int typeId = 13;

  @override
  AuthType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AuthType.facebook;
      case 1:
        return AuthType.apple;
      case 2:
        return AuthType.google;
      case 3:
        return AuthType.email;
      default:
        return AuthType.facebook;
    }
  }

  @override
  void write(BinaryWriter writer, AuthType obj) {
    switch (obj) {
      case AuthType.facebook:
        writer.writeByte(0);
        break;
      case AuthType.apple:
        writer.writeByte(1);
        break;
      case AuthType.google:
        writer.writeByte(2);
        break;
      case AuthType.email:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
