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
    String? localStoragePath,
    this.filePath,
    DateTime? canDeleteOn,
    String? postedBy,
    DateTime? timestamp,
    this.isLive = false,
    this.hasError = false,
    bool? isDownloaded,
  })  : postedBy = postedBy ?? AuthMethods.uid,
        localStoragePath = localStoragePath ?? '',
        isDownloaded = isDownloaded ?? postedBy == AuthMethods.uid,
        canDeleteOn =
            canDeleteOn ?? DateTime.now().add(const Duration(days: 30)),
        timestamp = timestamp ?? DateTime.now();

  @HiveField(0)
  final String url;
  @HiveField(1) // Class Code: 33
  final AttachmentType type;
  @HiveField(2)
  final String postedBy;
  @HiveField(3)
  final DateTime timestamp;
  @HiveField(4, defaultValue: '')
  final String attachmentID;
  @HiveField(5, defaultValue: '')
  final String storagePath;
  @HiveField(6, defaultValue: null)
  final DateTime? canDeleteOn;
  @HiveField(7, defaultValue: '')
  String localStoragePath;
  @HiveField(8, defaultValue: false)
  bool isLive;
  @HiveField(9, defaultValue: false)
  bool hasError;
  @HiveField(10, defaultValue: '')
  String? filePath;
  @HiveField(11, defaultValue: false)
  bool isDownloaded;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'type': type.json,
      'posted_by': postedBy,
      'timestamp': timestamp,
      'attachment_id': attachmentID,
      'storage_path': storagePath,
      'can_delete_on': canDeleteOn,
      'is_live': true,
      'has_error': false,
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
      canDeleteOn: TimeFun.parseTime(map['can_delete_on']),
      isLive: map['is_live'] ?? true,
      hasError: map['has_error'] ?? false,
    );
  }
}
