import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../models/board/task_list.dart';

class LocalTaskList {
  static const String _boxName = 'dm-task-list';

  static Future<Box<TaskList>> get openBox async =>
      await Hive.openBox<TaskList>(_boxName);

  static Future<void> get closeBox async =>
      Hive.box<TaskList>(_boxName).close();

  Future<Box<TaskList>> refresh() async {
    final bool isOpen = Hive.box<TaskList>(_boxName).isOpen;
    if (isOpen) {
      return Hive.box<TaskList>(_boxName);
    } else {
      return await openBox;
    }
  }

  //
  //
  Future<void> signOut() async {
    final Box<TaskList> box = await refresh();
    await box.clear();
  }

  ValueListenable<Box<TaskList>> listenable() {
    final bool isOpen = Hive.box<TaskList>(_boxName).isOpen;
    if (isOpen) {
      return Hive.box<TaskList>(_boxName).listenable();
    } else {
      openBox;
      return Hive.box<TaskList>(_boxName).listenable();
    }
  }
}
