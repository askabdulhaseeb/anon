
import 'package:hive_flutter/hive_flutter.dart';
part 'attachment_type.g.dart';

@HiveType(typeId: 33)
enum AttachmentType {
  @HiveField(0)
  photo('photo', 'Photo'),
  @HiveField(1)
  video('video', 'Video'),
  @HiveField(2)
  audio('audio', 'Audio'),
  @HiveField(3)
  document('document', 'Document'),
  @HiveField(4)
  other('other', 'Other');

  const AttachmentType(this.json, this.title);
  final String json;
  final String title;
}

class AttachmentTypeConvertor {
  AttachmentType toEnum(String type) {
    if (type == AttachmentType.photo.json) {
      return AttachmentType.photo;
    } else if (type == AttachmentType.video.json) {
      return AttachmentType.video;
    } else if (type == AttachmentType.audio.json) {
      return AttachmentType.audio;
    } else if (type == AttachmentType.document.json) {
      return AttachmentType.document;
    } else {
      return AttachmentType.other;
    }
  }
}
