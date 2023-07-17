import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../models/board/task_card.dart';

class LocalTaskCard {
  static const String _boxName = 'dm-task-card';

  static Future<Box<TaskCard>> get openBox async =>
      await Hive.openBox<TaskCard>(_boxName);

  static Future<void> get closeBox async =>
      Hive.box<TaskCard>(_boxName).close();

  Future<Box<TaskCard>> refresh() async {
    final bool isOpen = Hive.box<TaskCard>(_boxName).isOpen;
    if (isOpen) {
      return Hive.box<TaskCard>(_boxName);
    } else {
      return await openBox;
    }
  }

  Future<void> add(TaskCard value) async {
    try {
      final Box<TaskCard> box = await refresh();
      box.put(value.cardID, value);
    } catch (e) {
      debugPrint('$_boxName: ERROR - ${e.toString()}');
    }
  }

  Future<void> remove(TaskCard value) async {
    try {
      final Box<TaskCard> box = await refresh();
      box.delete(value.cardID);
    } catch (e) {
      debugPrint('$_boxName: ERROR - ${e.toString()}');
    }
  }

  //
  //
  Future<void> signOut() async {
    final Box<TaskCard> box = await refresh();
    await box.clear();
  }

  ValueListenable<Box<TaskCard>> listenable() {
    final bool isOpen = Hive.box<TaskCard>(_boxName).isOpen;
    if (isOpen) {
      return Hive.box<TaskCard>(_boxName).listenable();
    } else {
      openBox;
      return Hive.box<TaskCard>(_boxName).listenable();
    }
  }
}
