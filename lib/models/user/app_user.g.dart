// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppUserAdapter extends TypeAdapter<AppUser> {
  @override
  final int typeId = 1;

  @override
  AppUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppUser(
      uid: fields[0] as String,
      agencyIDs: (fields[14] as List).cast<String>(),
      name: fields[2] as String,
      phoneNumber: fields[7] as NumberDetails,
      email: fields[8] as String,
      password: fields[9] as String,
      type: fields[5] as UserType,
      defaultColor: fields[16] == null ? 808080 : fields[16] as int?,
      nickName: fields[3] as String?,
      authType: fields[6] as AuthType?,
      imageURL: fields[10] as String?,
      deviceToken: (fields[11] as List?)?.cast<MyDeviceToken>(),
      notAllowedWords: (fields[12] as List?)?.cast<String>(),
      status: fields[13] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AppUser obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.nickName)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.authType)
      ..writeByte(7)
      ..write(obj.phoneNumber)
      ..writeByte(8)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.password)
      ..writeByte(10)
      ..write(obj.imageURL)
      ..writeByte(11)
      ..write(obj.deviceToken)
      ..writeByte(12)
      ..write(obj.notAllowedWords)
      ..writeByte(13)
      ..write(obj.status)
      ..writeByte(14)
      ..write(obj.agencyIDs)
      ..writeByte(16)
      ..write(obj.defaultColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
