import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../models/board/task_card.dart';
import '../../local/board/local_task_card.dart';

class TaskCardAPI {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  static const String _collection = 'task-cards';

  Future<void> create(TaskCard value) async {
    try {
      await _instance
          .collection(_collection)
          .doc(value.cardID)
          .set(value.toMap());
      await LocalTaskCard().add(value);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> refreshCard(TaskCard value) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> result = await _instance
          .collection(_collection)
          .where('card_id', isEqualTo: value.cardID)
          .where('last_update', isGreaterThanOrEqualTo: value.lastUpdate)
          .get();
      if (result.docs.isEmpty) {
        value.lastFetch = DateTime.now();
        await LocalTaskCard().add(value);
      }
      for (DocumentChange<Map<String, dynamic>> element in result.docChanges) {
        final TaskCard updated = TaskCard.fromDoc(element.doc);
        if (element.type == DocumentChangeType.removed) {
          await LocalTaskCard().remove(updated);
        } else {
          await LocalTaskCard().add(updated);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
