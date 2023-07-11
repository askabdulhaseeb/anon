import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../enums/chat/message_type.dart';
import '../../enums/my_hive_type.dart';
import '../../models/chat/message.dart';
import '../../models/chat/message_read_info.dart';
import '../../models/project/attachment.dart';
import '../firebase/message_api.dart';
import 'local_unseen_message.dart';

class LocalMessage {
  static Future<Box<Message>> get openBox async =>
      await Hive.openBox<Message>(MyHiveType.message.database);

  static Future<void> get closeBox async =>
      Hive.box<Message>(MyHiveType.message.database).close();

  Future<Box<Message>> refresh() async {
    final bool isOpen = Hive.box<Message>(MyHiveType.message.database).isOpen;
    if (isOpen) {
      return Hive.box<Message>(MyHiveType.message.database);
    } else {
      return await openBox;
    }
  }

  Future<void> addMessage(Message value) async {
    try {
      final Box<Message> box = await refresh();
      
      box.put(value.messageID, value);
      if (!value.isSeenedMessage) {
        await LocalUnseenMessage().add(value);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> remove(Message value) async {
    try {
      final Box<Message> box = await refresh();
      box.delete(value.messageID);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> update(Message value) async {
    try {
      final Box<Message> box = await refresh();
      box.put(value.messageID, value);
      await MessageAPI().updateSeenTo(value: value);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Message> message(String chatID, String messageID) async {
    final Box<Message> box = await refresh();
    final Message? msg = box.get(messageID);
    if (msg != null) return msg;
    final Message? result = await MessageAPI().message(messageID: messageID);
    if (result != null) return result;
    return _null(chatID);
  }

  Future<void> updateSeenByMe(String chatID) async {
    final List<Message> mags =
        await LocalUnseenMessage().unseenMessageOfChat(chatID);
    if (mags.isEmpty) return;
    final List<Message> temp = <Message>[];
    for (Message value in mags) {
      value.updateSeenByMe();
      temp.add(value);
    }
    await LocalUnseenMessage().clearChat(chatID);
    // for (Message value in temp) {
    //   await update(value);
    // }
  }

  Future<Message> lastMessage(String chatID) async {
    final Box<Message> box = await refresh();
    final List<Message> msgs = box.values
        .where((Message element) => element.chatID == chatID)
        .toList();
    msgs.sort((Message a, Message b) => a.timestamp.compareTo(b.timestamp));
    return msgs.isEmpty ? _null(chatID) : msgs.last;
  }

  List<Message> boxToChatMessages({
    required Box<Message> box,
    required String chatID,
  }) {
    final List<Message> msgs = box.values
        .where((Message element) => element.chatID == chatID)
        .toList();
    msgs.sort((Message a, Message b) => b.timestamp.compareTo(a.timestamp));
    return msgs;
  }

  Future<void> signOut() async {
    final Box<Message> box = await refresh();
    await box.clear();
  }

  ValueListenable<Box<Message>> listenable() {
    final bool isOpen = Hive.box<Message>(MyHiveType.message.database).isOpen;
    if (isOpen) {
      return Hive.box<Message>(MyHiveType.message.database).listenable();
    } else {
      openBox;
      return Hive.box<Message>(MyHiveType.message.database).listenable();
    }
  }

  Message _null(String chatID) => Message(
        chatID: chatID,
        projectID: '',
        type: MessageType.text,
        attachment: <Attachment>[],
        sendTo: <MessageReadInfo>[],
        sendToUIDs: <String>[],
        text: 'null',
        displayString: 'null',
      );
}
