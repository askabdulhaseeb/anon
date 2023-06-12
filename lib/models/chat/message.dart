import 'package:hive/hive.dart';

import '../../database/firebase/auth_methods.dart';
import '../../enums/chat/message_type.dart';
import '../../functions/time_functions.dart';
import '../../functions/unique_id_fun.dart';
import '../project/attachment.dart';
import 'message_read_info.dart';
part 'message.g.dart';

@HiveType(typeId: 42)
class Message extends HiveObject {
  Message({
    required this.chatID,
    required this.type,
    required this.attachment,
    required this.sendTo,
    required this.sendToUIDs,
    required this.text,
    required this.displayString,
    String? messageID,
    DateTime? timestamp,
    String? sendBy,
    this.replyOf,
    this.isLive = true,
    this.refID,
    this.isEncrypted = false,
  })  : messageID = messageID ?? UniqueIdFun.messageID(chatID),
        timestamp = timestamp ?? DateTime.now(),
        sendBy = sendBy ?? AuthMethods.uid;

  @HiveField(0)
  final String messageID;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final String displayString;
  @HiveField(3) // Class Code: 44
  final MessageType type;
  @HiveField(4) // Class Code: 310
  final List<Attachment> attachment;
  @HiveField(5)
  final String sendBy;
  @HiveField(6)
  final String? refID;
  @HiveField(7) // Class Code: 45
  final List<MessageReadInfo> sendTo;
  @HiveField(8)
  final List<String> sendToUIDs;
  @HiveField(9)
  final DateTime timestamp;
  @HiveField(10) // Class Code: 42
  final Message? replyOf;
  @HiveField(11)
  final bool isLive;
  @HiveField(12, defaultValue: '')
  final String chatID;
  @HiveField(13, defaultValue: true)
  bool isEncrypted;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message_id': messageID,
      'chat_id': chatID,
      'text': text,
      'display_string': displayString,
      'type': type.json,
      'attachment': attachment.map((Attachment x) => x.toMap()).toList(),
      'send_by': sendBy,
      'send_to': sendTo.map((MessageReadInfo x) => x.toMap()).toList(),
      'send_to_uids': sendToUIDs,
      'reference_id': refID,
      'timestamp': timestamp,
      'reply_of': replyOf?.toMap(),
      'is_encrypted': isEncrypted = false,
    };
  }

  // ignore: sort_constructors_first
  factory Message.fromMap(Map<String, dynamic> map) {
    final String sendedBy = map['send_by'] ?? AuthMethods.uid;
    final bool isEnc = map['is_encrypted'];
    return Message(
      messageID: map['message_id'] ?? '',
      chatID: map['chat_id'] ?? '',
      text: map['text'],
      displayString: map['display_string'],
      sendToUIDs: List<String>.from((map['send_to_uids'] ?? <String>[])),
      type: MessageTypeConvertor().toEnum(map['type'] ?? MessageType.text.json),
      attachment: List<Attachment>.from(
          // ignore: always_specify_types
          map['attachment']?.map((x) => Attachment.fromMap(x))),
      sendBy: sendedBy,
      refID: map['reference_id'],
      sendTo: List<MessageReadInfo>.from(map['send_to']?.map(
        (dynamic x) => MessageReadInfo.fromMap(x),
      )),
      timestamp: TimeFun.parseTime(map['timestamp']),
      replyOf:
          map['reply_of'] != null ? Message.fromMap(map['reply_of']) : null,
      isLive: true,
      isEncrypted: isEnc,
    );
  }
}
