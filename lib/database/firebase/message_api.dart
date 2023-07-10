import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../../functions/time_functions.dart';
import '../../models/chat/message.dart';
import '../../models/user/app_user.dart';
import '../local/local_data.dart';
import '../local/local_message.dart';
import 'auth_methods.dart';

class MessageAPI {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  static const String _collection = 'messages';

  Stream<List<Message>> messages(String chatID) {
    return _instance
        .collection(_collection)
        .where('chat_id', isEqualTo: chatID)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> event) {
      final List<Message> messages = <Message>[];
      for (DocumentSnapshot<Map<String, dynamic>> element in event.docs) {
        final Message temp = Message.fromMap(element.data()!);
        messages.add(temp);
        LocalMessage().addMessage(temp);
      }
      return messages;
    });
  }

  Stream<List<Message>> messagesByProjectID(String projectID) {
    return _instance
        .collection(_collection)
        .where('project_id', isEqualTo: projectID)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> event) {
      final List<Message> messages = <Message>[];
      for (DocumentSnapshot<Map<String, dynamic>> element in event.docs) {
        final Message temp = Message.fromMap(element.data()!);
        messages.add(temp);
        LocalMessage().addMessage(temp);
      }
      return messages;
    });
  }

  Future<Message?> message({required String messageID}) async {
    final QuerySnapshot<Map<String, dynamic>> doc = await _instance
        .collection(_collection)
        .where('message_id', isEqualTo: messageID)
        .get();
    if (doc.docs.isEmpty) return null;
    return Message.fromMap(doc.docs[0].data());
  }

  Future<void> updateSeenTo({required Message value}) async {
    if (true) {
      debugPrint('Message API: Updating Unseen Messages not in work');
      return;
    }
    // await _instance
    //     .collection(_collection)
    //     .doc(value.messageID)
    //     .update(value.seenToMap());
  }

  Stream<void> refreshMessages() {
    final DateTime fetchingTime = DateTime.now();
    final int? temp = LocalData.lastMessageFetch();
    final DateTime updatedTime = temp == null
        ? DateTime.now().subtract(const Duration(days: 30))
        : TimeFun.miliToObject(temp);
    debugPrint('New Message fetching time: ${updatedTime.toString()}');
    return _instance
        .collection(_collection)
        .where('send_to_uids', arrayContains: AuthMethods.uid)
        .where('last_update', isGreaterThanOrEqualTo: updatedTime)
        .snapshots()
        .asyncMap((QuerySnapshot<Map<String, dynamic>> event) {
      _changeEventToLocal(event, fetchingTime);
      debugPrint('Request with time at: ${DateTime.now().toString()}');
    });
  }

  void _changeEventToLocal(
    QuerySnapshot<Map<String, dynamic>> event,
    DateTime fetchingTime,
  ) {
    final List<DocumentChange<Map<String, dynamic>>> changes = event.docChanges;
    if (changes.isEmpty) return;
    log('Message API: Add ${changes.length} new Messages');
    LocalData.setLastMessageFetch(fetchingTime.millisecondsSinceEpoch);
    for (DocumentChange<Map<String, dynamic>> element in changes) {
      final Message msg = Message.fromDoc(element.doc);
      if (element.type == DocumentChangeType.removed) {
        LocalMessage().remove(msg);
      } else {
        LocalMessage().addMessage(msg);
      }
    }
  }

  Future<void> sendMessage({
    required Message newMessage,
    required List<AppUser> receiver,
    required AppUser sender,
  }) async {
    await _instance
        .collection(_collection)
        .doc(newMessage.messageID)
        .set(newMessage.toMap());
    await LocalMessage().addMessage(newMessage);
    // if (receiver.deviceToken.isNotEmpty) {
    //     await NotificationsServices().sendSubsceibtionNotification(
    //       deviceToken: receiver.deviceToken,
    //       messageTitle: sender.displayName ?? 'App User',
    //       messageBody: newMessage!.text ?? 'Send you a message',
    //       data: <String>['chat', 'message', 'personal'],
    //     );
  }

  Future<(String path, String? url)> uploadAttachment({
    required File file,
    required String chatID,
    required String attachmentID,
  }) async {
    try {
      String tempPath = '$_collection/$chatID/$attachmentID}';
      TaskSnapshot snapshot =
          await FirebaseStorage.instance.ref(tempPath).putFile(file);
      String url = (await snapshot.ref.getDownloadURL()).toString();
      return (tempPath, url);
    } catch (e) {
      return ('', null);
    }
  }
}
