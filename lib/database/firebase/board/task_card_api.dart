import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../../../functions/time_functions.dart';
import '../../../functions/unique_id_fun.dart';
import '../../../models/board/task_card.dart';
import '../../../models/project/attachment.dart';
import '../../local/board/local_task_card.dart';
import '../../local/local_data.dart';

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

  Future<void> update(TaskCard value) async {
    try {
      await _instance
          .collection(_collection)
          .doc(value.cardID)
          .update(value.updateMap());
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

  Future<void> refreshCards(String boardID) async {
    try {
      final int time = DateTime.now().millisecondsSinceEpoch;
      final int? lastUpdate = LocalData.lastTaskCardFetch();
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
        LocalData.setTaskCardTimeKey(time);
      }
      for (DocumentChange<Map<String, dynamic>> element in result.docChanges) {
        final TaskCard updated = TaskCard.fromDoc(element.doc);
        if (element.type == DocumentChangeType.removed) {
          await LocalTaskCard().remove(updated);
        } else {
          await LocalTaskCard().add(updated);
        }
      }
      log('Card API: ${result.docChanges.length} Cards Refreshed');
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<Attachment>> uploadAttachments({
    required List<Attachment> attachments,
    required String cardID,
  }) async {
    try {
      print('${attachments.length} Uploading ...');
      final List<Attachment> cloudAttachments = <Attachment>[];
      if (attachments.isNotEmpty) {
        for (int i = 0; i < attachments.length; i++) {
          final String id = UniqueIdFun.unique();
          final Attachment attach = attachments[i];
          if (attach.filePath == null) continue;
          final (String path, String? url) = await _uploadAttachment(
            file: File(attach.filePath!),
            cardID: cardID,
            attachmentID: id,
          );
          cloudAttachments.add(
            Attachment(
              url: url ?? '',
              type: attach.type,
              attachmentID: id,
              storagePath: path,
              localStoragePath: attach.localStoragePath,
              filePath: attach.filePath,
              isLive: url == null ? false : true,
              hasError: url == null ? true : false,
            ),
          );
        }
      }
      print('${cloudAttachments.length} Uploaded');
      return cloudAttachments;
    } catch (e) {
      return (<Attachment>[]);
    }
  }

  Future<(String path, String? url)> _uploadAttachment({
    required File file,
    required String cardID,
    required String attachmentID,
  }) async {
    try {
      String tempPath = '$_collection/$cardID/$attachmentID}';
      TaskSnapshot snapshot =
          await FirebaseStorage.instance.ref(tempPath).putFile(file);
      String url = (await snapshot.ref.getDownloadURL()).toString();
      return (tempPath, url);
    } catch (e) {
      return ('', null);
    }
  }
}
