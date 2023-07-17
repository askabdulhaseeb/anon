import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../models/board/task_list.dart';
import '../../local/board/local_task_list.dart';

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
}
