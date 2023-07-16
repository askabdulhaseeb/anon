import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../models/board/board.dart';

class LocalBoard {
  static const String _boxName = 'dm-board';

  static Future<Box<Board>> get openBox async =>
      await Hive.openBox<Board>(_boxName);

  static Future<void> get closeBox async => Hive.box<Board>(_boxName).close();

  Future<Box<Board>> refresh() async {
    final bool isOpen = Hive.box<Board>(_boxName).isOpen;
    if (isOpen) {
      return Hive.box<Board>(_boxName);
    } else {
      return await openBox;
    }
  }

  //
  //
  Future<void> signOut() async {
    final Box<Board> box = await refresh();
    await box.clear();
  }

  ValueListenable<Box<Board>> listenable() {
    final bool isOpen = Hive.box<Board>(_boxName).isOpen;
    if (isOpen) {
      return Hive.box<Board>(_boxName).listenable();
    } else {
      openBox;
      return Hive.box<Board>(_boxName).listenable();
    }
  }
}
