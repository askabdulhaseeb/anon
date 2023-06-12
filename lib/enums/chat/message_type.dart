import 'package:hive/hive.dart';
part 'message_type.g.dart';

@HiveType(typeId: 44)
enum MessageType {
  @HiveField(0)
  text('Text', 'text'),
  @HiveField(1)
  image('Image', 'image'),
  @HiveField(2)
  audio('Audio', 'audio'),
  @HiveField(3)
  video('Video', 'video'),
  @HiveField(4)
  document('Document', 'document'),
  @HiveField(5)
  announcement('Announcement', 'announcement');

  const MessageType(this.title, this.json);
  final String title;
  final String json;
}

class MessageTypeConvertor {
  MessageType toEnum(String type) {
    if (type == MessageType.text.json) {
      return MessageType.text;
    } else if (type == MessageType.image.json) {
      return MessageType.image;
    } else if (type == MessageType.audio.json) {
      return MessageType.audio;
    } else if (type == MessageType.video.json) {
      return MessageType.video;
    } else if (type == MessageType.document.json) {
      return MessageType.document;
    } else if (type == MessageType.announcement.json) {
      return MessageType.announcement;
    } else {
      return MessageType.text;
    }
  }
}
