import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../functions/time_functions.dart';
import '../../../models/board/task_list.dart';
import '../../local/board/local_task_list.dart';
import '../../local/local_data.dart';

class TaskListAPI {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  static const String _collection = 'task-lists';

  Future<void> create(TaskList value) async {
    try {
      await _instance
          .collection(_collection)
          .doc(value.listID)
          .set(value.toMap());
      await LocalTaskList().add(value);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> refreshList(TaskList value) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> result = await _instance
          .collection(_collection)
          .where('list_id', isEqualTo: value.listID)
          .where('last_update', isGreaterThanOrEqualTo: value.lastUpdate)
          .get();
      if (result.docs.isEmpty) {
        value.lastFetch = DateTime.now();
        await LocalTaskList().add(value);
      }
      for (DocumentChange<Map<String, dynamic>> element in result.docChanges) {
        final TaskList updated = TaskList.fromDoc(element.doc);
        if (element.type == DocumentChangeType.removed) {
          await LocalTaskList().remove(updated);
        } else {
          await LocalTaskList().add(updated);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> refreshLists(String boardID) async {
    try {
      final int time = DateTime.now().millisecondsSinceEpoch;
      final int? lastUpdate = LocalData.lastTaskListFetch();
      final QuerySnapshot<Map<String, dynamic>> result = lastUpdate == null
          ? await _instance
              .collection(_collection)
              .where('board_id', isEqualTo: boardID)
              .get()
          : await _instance
              .collection(_collection)
              .where('board_id', isEqualTo: boardID)
              .where('last_update',
                  isGreaterThanOrEqualTo: TimeFun.miliToObject(lastUpdate)!
                      .subtract(const Duration(minutes: 2)))
              .get();
      if (result.docs.isNotEmpty) {
        LocalData.setTaskListTimeKey(time);
      }
      for (DocumentChange<Map<String, dynamic>> element in result.docChanges) {
        final TaskList updated = TaskList.fromDoc(element.doc);
        if (element.type == DocumentChangeType.removed) {
          await LocalTaskList().remove(updated);
        } else {
          await LocalTaskList().add(updated);
        }
      }
      log('List API: ${result.docChanges.length} Lists Refreshed');
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
