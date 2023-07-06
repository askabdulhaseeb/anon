import 'package:cloud_firestore/cloud_firestore.dart';
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
    required this.projectID,
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
    this.isEncrypted = false,
    this.isBuged = false,
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
  // 6 not for use
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
  @HiveField(14, defaultValue: '')
  final String projectID;
  @HiveField(15, defaultValue: false)
  final bool isBuged;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message_id': messageID,
      'chat_id': chatID,
      'project_id': projectID,
      'text': text,
      'display_string': displayString,
      'type': type.json,
      'attachment': attachment.map((Attachment x) => x.toMap()).toList(),
      'send_by': sendBy,
      'send_to': sendTo.map((MessageReadInfo x) => x.toMap()).toList(),
      'send_to_uids': sendToUIDs,
      'timestamp': timestamp,
      'reply_of': replyOf?.toMap(),
      'is_encrypted': isEncrypted = false,
      'is_buged': isBuged,
    };
  }

  // ignore: sort_constructors_first
  factory Message.fromMap(Map<String, dynamic> map) {
    final String sendedBy = map['send_by'] ?? AuthMethods.uid;
    final bool isEnc = map['is_encrypted'] ?? false;
    return Message(
      messageID: map['message_id'] ?? '',
      chatID: map['chat_id'] ?? '',
      projectID: map['project_id'] ?? '',
      text: map['text'] ?? '',
      displayString: map['display_string'] ?? '...',
      sendToUIDs: List<String>.from((map['send_to_uids'] ?? <String>[])),
      type: MessageTypeConvertor().toEnum(map['type'] ?? MessageType.text.json),
      attachment: List<Attachment>.from(
          // ignore: always_specify_types
          (map['attachment'] ?? <dynamic>[])
              ?.map((dynamic x) => Attachment.fromMap(x))),
      sendBy: sendedBy,
      sendTo: List<MessageReadInfo>.from((map['send_to'] ?? <dynamic>[])?.map(
        (dynamic x) => MessageReadInfo.fromMap(x),
      )),
      timestamp: TimeFun.parseTime(map['timestamp']),
      replyOf:
          map['reply_of'] != null ? Message.fromMap(map['reply_of']) : null,
      isLive: true,
      isBuged: map['is_buged'] ?? false,
      isEncrypted: isEnc,
    );
  }
  // ignore: sort_constructors_first
  factory Message.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final String sendedBy = doc.data()?['send_by'] ?? AuthMethods.uid;
    final bool isEnc = doc.data()?['is_encrypted'] ?? false;
    return Message(
      messageID: doc.data()?['message_id'] ?? '',
      chatID: doc.data()?['chat_id'] ?? '',
      projectID: doc.data()?['project_id'] ?? '',
      text: doc.data()?['text'] ?? '',
      displayString: doc.data()?['display_string'] ?? '...',
      sendToUIDs:
          List<String>.from((doc.data()?['send_to_uids'] ?? <String>[])),
      type: MessageTypeConvertor()
          .toEnum(doc.data()?['type'] ?? MessageType.text.json),
      attachment: List<Attachment>.from(
          // ignore: always_specify_types
          (doc.data()?['attachment'] ?? <dynamic>[])
              ?.map((dynamic x) => Attachment.fromMap(x))),
      sendBy: sendedBy,
      sendTo: List<MessageReadInfo>.from(
          (doc.data()?['send_to'] ?? <dynamic>[])?.map(
        (dynamic x) => MessageReadInfo.fromMap(x),
      )),
      timestamp: TimeFun.parseTime(doc.data()?['timestamp']),
      replyOf: doc.data()?['reply_of'] != null
          ? Message.fromMap(doc.data()?['reply_of'])
          : null,
      isLive: true,
      isBuged: doc.data()?['is_buged'] ?? false,
      isEncrypted: isEnc,
    );
  }
}
