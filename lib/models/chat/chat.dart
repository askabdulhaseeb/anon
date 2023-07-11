import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devmarkaz/models/chat/target_string.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../database/firebase/auth_methods.dart';
import '../../enums/chat/chat_member_role.dart';
import '../../functions/helping_funcation.dart';
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
    int? defaultColor,
    String? chatID,
    List<Note>? chatNotes,
    List<Message>? unseenMessages,
    DateTime? timestamp,
    DateTime? lastUpdate,
    List<TargetString>? targetString,
  })  : chatID = chatID ?? UniqueIdFun.unique(),
        chatNotes = chatNotes ?? <Note>[],
        unseenMessages = unseenMessages ?? <Message>[],
        timestamp = timestamp ?? DateTime.now(),
        lastUpdate = lastUpdate ?? DateTime.now(),
        defaultColor = defaultColor ?? HelpingFuncation().randomColor(),
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
  @HiveField(12, defaultValue: 808080)
  final int defaultColor;
  @HiveField(13)
  DateTime lastUpdate;

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
      'default_color': defaultColor,
      'timestamp': timestamp,
      'last_update': lastUpdate = DateTime.now(),
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
      'timestamp': DateTime.now(),
      'last_update': lastUpdate = DateTime.now(),
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
      defaultColor: map['default_color'] ?? Colors.grey.value,
      chatNotes: List<Note>.from(map['notes']?.map(
        (dynamic x) => Note.fromMap(x),
      )),
      lastMessage: map['last_message'] != null
          ? Message.fromMap(map['last_message'])
          : null,
      unseenMessages: List<Message>.from(
          (map['unseen_message'] as List<dynamic>).map<Message>(
        (dynamic x) => Message.fromMap(x),
      )),
      members: List<ChatMember>.from(
          (map['members'] as List<dynamic>).map<ChatMember>(
        (dynamic x) => ChatMember.fromMap(x),
      )),
      timestamp: TimeFun.parseTime(map['timestamp']),
      lastUpdate: TimeFun.parseTime(map['last_update']),
    );
  }

  // ignore: sort_constructors_first
  factory Chat.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Chat(
      chatID: doc.data()?['chat_id'] ?? '',
      imageURL: doc.data()?['image_url'] ?? '',
      title: doc.data()?['title'] ?? '',
      description: doc.data()?['description'] ?? '',
      persons: List<String>.from((doc.data()?['persons'] ?? <String>[])),
      projectID: doc.data()?['project_id'] ?? '',
      defaultColor: doc.data()?['default_color'] ?? Colors.grey.value,
      chatNotes: List<Note>.from(doc.data()?['notes']?.map(
            (dynamic x) => Note.fromMap(x),
          )),
      lastMessage: doc.data()?['last_message'] != null
          ? Message.fromMap(doc.data()?['last_message'])
          : null,
      unseenMessages: List<Message>.from(
          (doc.data()?['unseen_message'] as List<dynamic>).map<Message>(
        (dynamic x) => Message.fromMap(x),
      )),
      members: List<ChatMember>.from(
          (doc.data()?['members'] as List<dynamic>).map<ChatMember>(
        (dynamic x) => ChatMember.fromMap(x),
      )),
      timestamp: TimeFun.parseTime(doc.data()?['timestamp']),
      lastUpdate: TimeFun.parseTime(doc.data()?['last_update']),
    );
  }
}
