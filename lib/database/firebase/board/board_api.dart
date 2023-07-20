import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../../enums/chat/chat_member_role.dart';
import '../../../functions/time_functions.dart';
import '../../../models/board/board.dart';
import '../../../models/board/board_member.dart';
import '../../../models/board/task_list.dart';
import '../../../models/project/project.dart';
import '../../local/board/local_board.dart';
import '../../local/local_data.dart';
import '../auth_methods.dart';
import 'task_list_api.dart';

class BoardAPI {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  static const String _collection = 'boards';

  Future<void> create(Board value) async {
    try {
      await _instance
          .collection(_collection)
          .doc(value.boardID)
          .set(value.toMap());
      await LocalBoard().add(value);
      await TaskListAPI().create(
        TaskList(boardID: value.boardID, title: 'To Do', position: 0),
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> createProjectBoard(Project value) async {
    try {
      await BoardAPI().create(Board(
          title: value.title,
          projectID: value.pid,
          persons: value.members,
          members: value.members
              .map((String e) => BoardMember(
                    uid: e,
                    isRequestPending: false,
                    invitationAccepted: true,
                    role: value.createdBy == e
                        ? ChatMemberRole.admin
                        : ChatMemberRole.member,
                  ))
              .toList()));
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> refreshBoards() async {
    final int time = DateTime.now().millisecondsSinceEpoch;
    final int? lastUpdate = LocalData.lastBoardFetch();
    try {
      final QuerySnapshot<Map<String, dynamic>> result = lastUpdate == null
          ? await _instance
              .collection(_collection)
              .where('persons', arrayContains: AuthMethods.uid)
              .get()
          : await _instance
              .collection(_collection)
              .where('persons', arrayContains: AuthMethods.uid)
              .where('last_update',
                  isGreaterThanOrEqualTo: TimeFun.miliToObject(lastUpdate)!
                      .subtract(const Duration(hours: 1)))
              .get();
      if (result.docs.isNotEmpty) {
        LocalData.setBoardTimeKey(time);
      }
      for (DocumentChange<Map<String, dynamic>> element in result.docChanges) {
        final Board updated = Board.fromDoc(element.doc);
        if (element.type == DocumentChangeType.removed ||
            !updated.persons.contains(AuthMethods.uid)) {
          await LocalBoard().remove(updated);
        } else {
          await LocalBoard().add(updated);
        }
      }
      log('Board API: ${result.docChanges.length} Boards Refreshed');
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
        if (element.type == DocumentChangeType.removed ||
            !updated.persons.contains(AuthMethods.uid)) {
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

  Future<void> refreshBoardByProjectID(String projectID) async {
    final QuerySnapshot<Map<String, dynamic>> result = await _instance
        .collection(_collection)
        .where('project_id', isEqualTo: projectID)
        .get();
    if (result.docs.isEmpty) return;
    for (DocumentSnapshot<Map<String, dynamic>> element in result.docs) {
      final Board updated = Board.fromDoc(element);
      if (updated.persons.contains(AuthMethods.uid)) {
        await LocalBoard().add(updated);
      }
    }
  }

  Future<void> refreshBoardByBoardID(String boardID) async {
    final DocumentSnapshot<Map<String, dynamic>> result =
        await _instance.collection(_collection).doc(boardID).get();
    if (!result.exists) return;
    final Board updated = Board.fromDoc(result);
    if (updated.persons.contains(AuthMethods.uid)) {
      await LocalBoard().add(updated);
    }
  }
}
