import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../models/board/board.dart';
import '../../firebase/board/board_api.dart';

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

  Future<void> add(Board value) async {
    try {
      final Box<Board> box = await refresh();
      box.put(value.boardID, value);
    } catch (e) {
      debugPrint('$_boxName: ERROR - ${e.toString()}');
    }
  }

  Future<Board?> boardByProjectID(String projectID) async {
    final Box<Board> box = await refresh();
    try {
      return box.values
          .firstWhere((Board element) => element.projectID == projectID);
    } catch (e) {
      debugPrint('$_boxName: ERROR - ${e.toString()}');
      await BoardAPI().refreshBoardByProjectID(projectID);
      try {
        return box.values
            .firstWhere((Board element) => element.projectID == projectID);
      } catch (_) {}
    }
    return null;
  }

  Future<void> remove(Board value) async {
    try {
      final Box<Board> box = await refresh();
      box.delete(value.boardID);
    } catch (e) {
      debugPrint('$_boxName: ERROR - ${e.toString()}');
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
