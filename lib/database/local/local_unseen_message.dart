import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/chat/message.dart';
import '../../models/chat/unseen_message.dart';

class LocalUnseenMessage {
  static const String _boxName = 'dm-unseen-messages';
  static Future<Box<UnseenMessage>> get openBox async =>
      await Hive.openBox<UnseenMessage>(_boxName);

  static Future<void> get closeBox async =>
      Hive.box<UnseenMessage>(_boxName).close();

  Future<Box<UnseenMessage>> refresh() async {
    final bool isOpen = Hive.box<UnseenMessage>(_boxName).isOpen;
    if (isOpen) {
      return Hive.box<UnseenMessage>(_boxName);
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
      box.delete(chatID);
      debugPrint(
          'Chat Id: ($chatID) is Clear: ${box.get(chatID)?.unseenMessages.length}');
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
    final UnseenMessage? chatResult = box.get(chatID);
    return chatResult == null
        ? <String>[]
        : chatResult.unseenMessages
            .map((Message e) => e.sendBy)
            .toSet()
            .toList();
  }

  List<String> boxToProjectUnseenMessages({
    required Box<UnseenMessage> box,
    required String projID,
  }) {
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

  List<String> boxToChatUnseenMessages({
    required Box<UnseenMessage> box,
    required String chatID,
  }) {
    final UnseenMessage? chatResult = box.get(chatID);
    return chatResult == null
        ? <String>[]
        : chatResult.unseenMessages
            .map((Message e) => e.sendBy)
            .toSet()
            .toList();
  }

  Future<List<Message>> unseenMessageOfChat(String chatID) async {
    final Box<UnseenMessage> box = await refresh();
    final UnseenMessage? chatResult = box.get(chatID);
    return chatResult == null ? <Message>[] : chatResult.unseenMessages;
  }

  Future<void> signOut() async {
    final Box<UnseenMessage> box = await refresh();
    await box.clear();
  }

  ValueListenable<Box<UnseenMessage>> listenable() {
    final bool isOpen = Hive.box<UnseenMessage>(_boxName).isOpen;
    if (isOpen) {
      return Hive.box<UnseenMessage>(_boxName).listenable();
    } else {
      openBox;
      return Hive.box<UnseenMessage>(_boxName).listenable();
    }
  }
}
