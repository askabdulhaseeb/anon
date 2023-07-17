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

  Future<void> add(TaskList value) async {
    try {
      final Box<TaskList> box = await refresh();
      box.put(value.listID, value);
    } catch (e) {
      debugPrint('$_boxName: ERROR - ${e.toString()}');
    }
  }

  Future<List<TaskList>> listByBoardID(String boardID) async {
    try {
      final Box<TaskList> box = await refresh();
      final List<TaskList> result = box.values
          .where((TaskList element) => element.boardID == boardID)
          .toList();
      if (result.length <= 1) return result;
      result.sort((TaskList a, TaskList b) => a.position.compareTo(b.position));
      return result;
    } catch (e) {
      debugPrint('$_boxName: ERROR - ${e.toString()}');
      return <TaskList>[];
    }
  }

  Future<void> remove(TaskList value) async {
    try {
      final Box<TaskList> box = await refresh();
      box.delete(value.listID);
    } catch (e) {
      debugPrint('$_boxName: ERROR - ${e.toString()}');
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
