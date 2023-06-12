import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../enums/my_hive_type.dart';
import '../../models/chat/chat.dart';
import '../../models/chat/chat_group_member.dart';
import '../firebase/chat_api.dart';

class LocalChat {
  static Future<Box<Chat>> get openBox async =>
      await Hive.openBox<Chat>(MyHiveType.chat.database);

  static Future<void> get closeBox async =>
      Hive.box<Chat>(MyHiveType.chat.database).close();

  Future<Box<Chat>> refresh() async {
    final bool isOpen = Hive.box<Chat>(MyHiveType.chat.database).isOpen;
    if (isOpen) {
      return Hive.box<Chat>(MyHiveType.chat.database);
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

  Future<void> signOut() async {
    final Box<Chat> box = await refresh();
    await box.clear();
  }

  ValueListenable<Box<Chat>> listenable() {
    final bool isOpen = Hive.box<Chat>(MyHiveType.chat.database).isOpen;
    if (isOpen) {
      return Hive.box<Chat>(MyHiveType.chat.database).listenable();
    } else {
      openBox;
      return Hive.box<Chat>(MyHiveType.chat.database).listenable();
    }
  }
}
