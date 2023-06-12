import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../enums/my_hive_type.dart';
import '../../models/chat/message.dart';

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
}
