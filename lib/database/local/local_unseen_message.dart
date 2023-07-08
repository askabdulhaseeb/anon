import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../enums/my_hive_type.dart';
import '../../models/chat/message.dart';
import '../../models/chat/unseen_message.dart';

class LocalUnseenMessage {
  static Future<Box<UnseenMessage>> get openBox async =>
      await Hive.openBox<UnseenMessage>(MyHiveType.unseenMessage.database);

  static Future<void> get closeBox async =>
      Hive.box<UnseenMessage>(MyHiveType.unseenMessage.database).close();

  Future<Box<UnseenMessage>> refresh() async {
    final bool isOpen =
        Hive.box<UnseenMessage>(MyHiveType.unseenMessage.database).isOpen;
    if (isOpen) {
      return Hive.box<UnseenMessage>(MyHiveType.unseenMessage.database);
    } else {
      return await openBox;
    }
  }

  Future<void> add(Message value) async {
    try {
      final Box<UnseenMessage> box = await refresh();
      final UnseenMessage result = box.values.firstWhere(
        (UnseenMessage element) => element.chatID == value.chatID,
        orElse: () => UnseenMessage(
          chatID: value.chatID,
          projectID: value.projectID,
          lastMessageAdded: value.lastUpdate,
          unseenMessages: <Message>[],
        ),
      );
      result.addMessge(value);
      box.put(value.chatID, result);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> clearChat(String chatID) async {
    try {
      final Box<UnseenMessage> box = await refresh();
      box.values
          .firstWhere((UnseenMessage element) => element.chatID == chatID)
          .unseenMessages
          .clear();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<String>> listOfProjectUnseenMessages(String projID) async {
    final Box<UnseenMessage> box = await refresh();
    final List<UnseenMessage> allChats = box.values
        .where((UnseenMessage element) => element.projectID == projID)
        .toList();
    final Set<String> persons = <String>{};
    for (UnseenMessage element in allChats) {
      persons
          .addAll(element.unseenMessages.map((Message e) => e.sendBy).toSet());
    }
    return persons.toList();
  }

  Future<List<String>> listOfChatUnseenMessages(String chatID) async {
    final Box<UnseenMessage> box = await refresh();
    final List<UnseenMessage> allChats = box.values
        .where((UnseenMessage element) => element.chatID == chatID)
        .toList();
    final Set<String> persons = <String>{};
    for (UnseenMessage element in allChats) {
      persons
          .addAll(element.unseenMessages.map((Message e) => e.sendBy).toSet());
    }
    return persons.toList();
  }

  Future<void> signOut() async {
    final Box<UnseenMessage> box = await refresh();
    await box.clear();
  }

  ValueListenable<Box<UnseenMessage>> listenable() {
    final bool isOpen =
        Hive.box<UnseenMessage>(MyHiveType.unseenMessage.database).isOpen;
    if (isOpen) {
      return Hive.box<UnseenMessage>(MyHiveType.unseenMessage.database)
          .listenable();
    } else {
      openBox;
      return Hive.box<UnseenMessage>(MyHiveType.unseenMessage.database)
          .listenable();
    }
  }
}
