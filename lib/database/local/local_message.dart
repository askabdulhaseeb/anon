import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../enums/chat/message_type.dart';
import '../../enums/my_hive_type.dart';
import '../../models/chat/message.dart';
import '../../models/chat/message_read_info.dart';
import '../../models/project/attachment.dart';
import '../firebase/auth_methods.dart';
import '../firebase/message_api.dart';

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

  Future<Message> lastMessage(String chatID) async {
    final Box<Message> box = await refresh();
    return box.values.lastWhere((Message element) => element.chatID == chatID,
        orElse: () => _null(chatID));
  }

  Future<List<String>> listOfUnseenMessages(String projID) async {
    final String me = AuthMethods.uid;
    final Box<Message> box = await refresh();
    final List<Message> msgs = box.values
        .where((Message element) => element.sendTo
            // .any((MessageReadInfo ele) => ele.uid == me && ele.seen == true))
            .any((MessageReadInfo ele) => ele.seen == true))
        .toList();
    return msgs.map((Message e) => e.sendBy).toSet().toList();
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
