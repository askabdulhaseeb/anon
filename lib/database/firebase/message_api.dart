import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/chat/message.dart';
import '../../models/user/app_user.dart';
import '../../widgets/custom/custom_toast.dart';
import '../local/local_message.dart';

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

  Future<void> sendMessage({
    required Message newMessage,
    required List<AppUser> receiver,
    required AppUser sender,
  }) async {
    await _instance.collection(_collection).doc().set(newMessage.toMap());
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
      CustomToast.errorToast(message: e.toString());
      return ('', null);
    }
  }
}
