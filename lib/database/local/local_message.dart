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
      if (value.isSeenedMessage) {
        await LocalUnseenMessage().add(value);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> update(Message value) async {
    try {
      final Box<Message> box = await refresh();
      box.put(value.messageID, value);
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

  Future<void> updateSeenByMe(Message value) async {
    value.updateSeenByMe();
    await update(value);
    await LocalUnseenMessage().clearChat(value.chatID);
  }

  Future<Message> lastMessage(String chatID) async {
    final Box<Message> box = await refresh();
    final List<Message> msgs = box.values
        .where((Message element) => element.chatID == chatID)
        .toList();
    msgs.sort((Message a, Message b) => a.timestamp.compareTo(b.timestamp));
    return msgs.last;
  }

  Future<List<String>> listOfProjectUnseenMessages(String projID) async {
    return await LocalUnseenMessage().listOfProjectUnseenMessages(projID);
  }

  Future<List<String>> listOfChatUnseenMessages(String chatID) async {
    return await LocalUnseenMessage().listOfChatUnseenMessages(chatID);
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
