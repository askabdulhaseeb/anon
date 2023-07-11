// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttachmentAdapter extends TypeAdapter<Attachment> {
  @override
  final int typeId = 32;

  @override
  Attachment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Attachment(
      url: fields[0] as String,
      type: fields[1] as AttachmentType,
      attachmentID: fields[4] == null ? '' : fields[4] as String,
      storagePath: fields[5] == null ? '' : fields[5] as String,
      localStoragePath: fields[7] == null ? '' : fields[7] as String?,
      filePath: fields[10] == null ? '' : fields[10] as String?,
      canDeleteOn: fields[6] as DateTime?,
      postedBy: fields[2] as String?,
      timestamp: fields[3] as DateTime?,
      isLive: fields[8] == null ? false : fields[8] as bool,
      hasError: fields[9] == null ? false : fields[9] as bool,
      isDownloaded: fields[11] == null ? false : fields[11] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Attachment obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.postedBy)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.attachmentID)
      ..writeByte(5)
      ..write(obj.storagePath)
      ..writeByte(6)
      ..write(obj.canDeleteOn)
      ..writeByte(7)
      ..write(obj.localStoragePath)
      ..writeByte(8)
      ..write(obj.isLive)
      ..writeByte(9)
      ..write(obj.hasError)
      ..writeByte(10)
      ..write(obj.filePath)
      ..writeByte(11)
      ..write(obj.isDownloaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
