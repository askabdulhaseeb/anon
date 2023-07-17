import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../../models/board/board.dart';
import '../../local/board/local_board.dart';

class BoardAPI {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  static const String _collection = 'boards';

  Future<void> create(Board value) async {
    try {
      await _instance
          .collection(_collection)
          .doc(value.boardID)
          .set(value.toMap());
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> refreshBoard(Board value) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> result = await _instance
          .collection(_collection)
          .where('board_id', isEqualTo: value.boardID)
          .where('last_update', isGreaterThanOrEqualTo: value.lastUpdate)
          .get();
      if (result.docs.isEmpty) {
        value.lastFetch = DateTime.now();
        await LocalBoard().add(value);
      }
      for (DocumentChange<Map<String, dynamic>> element in result.docChanges) {
        final Board updated = Board.fromDoc(element.doc);
        if (element.type == DocumentChangeType.removed) {
          await LocalBoard().remove(updated);
        } else {
          await LocalBoard().add(updated);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
