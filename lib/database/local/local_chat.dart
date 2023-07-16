import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/chat/chat.dart';
import '../../models/chat/chat_group_member.dart';
import '../firebase/chat_api.dart';

class LocalChat {
  static const String _boxName = 'dm-chats';
  static Future<Box<Chat>> get openBox async =>
      await Hive.openBox<Chat>(_boxName);

  static Future<void> get closeBox async => Hive.box<Chat>(_boxName).close();

  Future<Box<Chat>> refresh() async {
    final bool isOpen = Hive.box<Chat>(_boxName).isOpen;
    if (isOpen) {
      return Hive.box<Chat>(_boxName);
    } else {
      return await openBox;
    }
  }

  Future<void> addChat(Chat value) async {
    try {
      final Box<Chat> box = await refresh();
      box.put(value.chatID, value);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> remove(String value) async {
    try {
      final Box<Chat> box = await refresh();
      box.delete(value);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addAllChat(List<Chat> value) async {
    try {
      final Box<Chat> box = await refresh();
      await box.clear();
      for (Chat element in value) {
        box.put(element.chatID, element);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Chat> chat(String chatID) async {
    final Box<Chat> box = await refresh();
    final Chat? result = box.get(chatID);
    if (result == null) {
      final Chat? newResult = await ChatAPI().chat(chatID);
      if (newResult == null) {
        return Chat(
          imageURL: '',
          persons: <String>[],
          projectID: '',
          members: <ChatMember>[],
        );
      }
      await addChat(newResult);
      return newResult;
    }
    return result;
  }

  List<Chat> boxToChats({required Box<Chat> box, required String projID}) {
    return box.values
        .where((Chat element) => element.projectID == projID)
        .toList();
  }

  Future<void> addMember(Chat value) async {
    final Box<Chat> box = await refresh();
    await box.put(value.chatID, value);
    await ChatAPI().toAddMember(value);
  }

  Future<void> updateMember(Chat value) async {
    final Box<Chat> box = await refresh();
    await box.put(value.chatID, value);
    await ChatAPI().updateMembers(value);
  }

  Future<void> signOut() async {
    final Box<Chat> box = await refresh();
    await box.clear();
  }

  ValueListenable<Box<Chat>> listenable() {
    final bool isOpen = Hive.box<Chat>(_boxName).isOpen;
    if (isOpen) {
      return Hive.box<Chat>(_boxName).listenable();
    } else {
      openBox;
      return Hive.box<Chat>(_boxName).listenable();
    }
  }
}
