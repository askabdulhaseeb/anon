import 'package:hive/hive.dart';
import '../../database/firebase/auth_methods.dart';
import '../../enums/attachment_type.dart';
import '../../functions/time_functions.dart';

part 'attachment.g.dart';

@HiveType(typeId: 32)
class Attachment {
  Attachment({
    required this.url,
    required this.type,
    required this.attachmentID,
    required this.storagePath,
    String? postedBy,
    DateTime? timestamp,
  })  : postedBy = postedBy ?? AuthMethods.uid,
        timestamp = timestamp ?? DateTime.now();

  @HiveField(0)
  final String url;
  @HiveField(1) // Class Code: 3100
  final AttachmentType type;
  @HiveField(2)
  final String postedBy;
  @HiveField(3)
  final DateTime timestamp;
  @HiveField(4, defaultValue: '')
  final String attachmentID;
  @HiveField(5, defaultValue: '')
  final String storagePath;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'type': type.json,
      'posted_by': postedBy,
      'timestamp': timestamp,
      'attachment_id': attachmentID,
      'storage_path': storagePath,
    };
  }

  // ignore: sort_constructors_first
  factory Attachment.fromMap(Map<String, dynamic> map) {
    return Attachment(
      url: map['url'] ?? '',
      attachmentID: map['attachment_id'] ?? '',
      storagePath: map['storage_path'] ?? '',
      type: AttachmentTypeConvertor()
          .toEnum(map['type'] ?? AttachmentType.other.json),
      postedBy: map['posted_by'] ?? '',
      timestamp: TimeFun.parseTime(map['timestamp']),
    );
  }
}
