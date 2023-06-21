import 'package:devmarkaz/models/chat/target_string.dart';
import 'package:hive/hive.dart';

import '../../database/firebase/auth_methods.dart';
import '../../enums/chat/chat_member_role.dart';
import '../../functions/time_functions.dart';
import '../../functions/unique_id_fun.dart';
import '../project/note.dart';
import 'chat_group_member.dart';
import 'message.dart';
part 'chat.g.dart';

@HiveType(typeId: 4)
class Chat extends HiveObject {
  Chat({
    required this.imageURL,
    required this.persons,
    required this.projectID,
    required this.members,
    this.title = '',
    this.description = '',
    this.lastMessage,
    String? chatID,
    List<Note>? chatNotes,
    List<Message>? unseenMessages,
    DateTime? timestamp,
    List<TargetString>? targetString,
  })  : chatID = chatID ?? UniqueIdFun.unique(),
        chatNotes = chatNotes ?? <Note>[],
        unseenMessages = unseenMessages ?? <Message>[],
        timestamp = timestamp ?? DateTime.now(),
        targetString = targetString ?? <TargetString>[];

  @HiveField(0)
  final String chatID;
  @HiveField(1)
  final List<String> persons;
  @HiveField(2)
  final String projectID;
  @HiveField(3) // Class code: 31
  final List<Note> chatNotes;
  @HiveField(4) // Class Code: 41 & 43
  final List<ChatMember> members;
  @HiveField(5) // Class Code: 42, 44 & 45
  Message? lastMessage;
  @HiveField(6) // Class Code: 42, 44 & 45
  List<Message> unseenMessages;
  @HiveField(7)
  DateTime timestamp;
  @HiveField(8, defaultValue: '')
  String imageURL;
  @HiveField(9, defaultValue: '')
  String title;
  @HiveField(10, defaultValue: '')
  String description;
  @HiveField(11) // Class Code: 46 & 47
  final List<TargetString> targetString;

  Map<String, dynamic> toMap() {
    final String me = AuthMethods.uid;
    if (!persons.contains(me)) persons.add(me);
    if (!members.any((ChatMember element) => element.uid == me)) {
      members.add(ChatMember(uid: me, role: ChatMemberRole.admin));
    }
    return <String, dynamic>{
      'chat_id': chatID,
      'project_id': projectID,
      'persons': persons,
      'title': title,
      'description': description,
      'image_url': imageURL,
      'notes': chatNotes.map((Note x) => x.toMap()).toList(),
      'members': members.map((ChatMember x) => x.toMap()).toList(),
      'last_message': lastMessage?.toMap(),
      'unseen_message': unseenMessages.map((Message x) => x.toMap()).toList(),
      'timestamp': timestamp,
    };
  }

  Map<String, dynamic> toAddMember() {
    final String me = AuthMethods.uid;
    if (!persons.contains(me)) persons.add(me);
    if (!members.any((ChatMember element) => element.uid == me)) {
      members.add(ChatMember(uid: me, role: ChatMemberRole.admin));
    }
    return <String, dynamic>{
      'persons': persons,
      'members': members.map((ChatMember x) => x.toMap()).toList(),
    };
  }

  // ignore: sort_constructors_first
  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      chatID: map['chat_id'] ?? '',
      imageURL: map['image_url'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      persons: List<String>.from((map['persons'] ?? <String>[])),
      projectID: map['project_id'] ?? '',
      chatNotes: List<Note>.from(map['notes']?.map(
        (dynamic x) => Note.fromMap(x),
      )),
      lastMessage: map['last_message'] != null
          ? Message.fromMap(map['last_message'])
          : null,
      unseenMessages: List<Message>.from(map['unseen_message']?.map(
        (dynamic x) => Message.fromMap(x),
      )),
      members: List<ChatMember>.from(map['members']?.map(
        (dynamic x) => ChatMember.fromMap(x),
      )),
      timestamp: TimeFun.parseTime(map['timestamp']),
    );
  }
}
