import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/chat/chat.dart';
import '../../models/chat/message.dart';
import '../../models/user/app_user.dart';
import '../../widgets/custom/custom_toast.dart';
import 'auth_methods.dart';

class ChatAPI {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  static const String _collection = 'chats';
  static const String _subCollection = 'messages';

  Stream<List<Message>> messages(String chatID) {
    return _instance
        .collection(_collection)
        .doc(chatID)
        .collection(_subCollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> event) {
      final List<Message> messages = <Message>[];
      for (DocumentSnapshot<Map<String, dynamic>> element in event.docs) {
        final Message temp = Message.fromMap(element.data()!);
        messages.add(temp);
      }
      return messages;
    });
  }

  Stream<List<Chat>> chats(String projectID) {
    // Firebase Index need to add
    // Composite Index
    // Collection ID -> chat
    // Field Indexed -> persons Arrays is_group Ascending timestamp Descending
    return _instance
        .collection(_collection)
        .where('persons', arrayContains: AuthMethods.uid)
        .where('project_id', isEqualTo: projectID)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot<Map<String, dynamic>> event) {
      List<Chat> chats = <Chat>[];
      for (DocumentSnapshot<Map<String, dynamic>> element in event.docs) {
        final Chat temp = Chat.fromMap(element.data()!);
        chats.add(temp);
      }
      return chats;
    });
  }

  Future<List<Chat>> chatsAndGroups() async {
    List<Chat> chats = <Chat>[];
    try {
      final QuerySnapshot<Map<String, dynamic>> docs = await _instance
          .collection(_collection)
          .where('persons', arrayContains: AuthMethods.uid)
          .get();

      for (DocumentSnapshot<Map<String, dynamic>> element in docs.docs) {
        final Chat temp = Chat.fromMap(element.data()!);
        chats.add(temp);
      }
    } catch (e) {
      log('Chat API - ERROR: ${e.toString()}');
    }
    return chats;
  }

  Future<void> sendMessage({
    required Chat chat,
    required List<AppUser> receiver,
    required AppUser sender,
  }) async {
    final Message? newMessage = chat.lastMessage;
    try {
      if (newMessage != null) {
        await _instance
            .collection(_collection)
            .doc(chat.chatID)
            .collection(_subCollection)
            .doc(newMessage.messageID)
            .set(newMessage.toMap());
      }
      await _instance
          .collection(_collection)
          .doc(chat.chatID)
          .set(chat.toMap());
      // if (receiver.deviceToken.isNotEmpty) {
      //   await NotificationsServices().sendSubsceibtionNotification(
      //     deviceToken: receiver.deviceToken,
      //     messageTitle: sender.displayName ?? 'App User',
      //     messageBody: newMessage!.text ?? 'Send you a message',
      //     data: <String>['chat', 'message', 'personal'],
      //   );
      // }
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
  }

  // Future<void> addMembers(Chat chat) async {
  //   final Message? newMessage = chat.lastMessage;
  //   try {
  //     if (newMessage != null) {
  //       await _instance
  //           .collection(_collection)
  //           .doc(chat.chatID)
  //           .update(chat.addMembers());
  //       await _instance
  //           .collection(_collection)
  //           .doc(chat.chatID)
  //           .collection(_subCollection)
  //           .doc(newMessage.messageID)
  //           .set(newMessage.toMap());
  //     }
  //   } catch (e) {
  //     CustomToast.errorToast(message: e.toString());
  //   }
  // }

  Future<String?> uploadAttachment({
    required File file,
    required String attachmentID,
  }) async {
    try {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('$_collection/projects/$attachmentID}')
          .putFile(file);
      String url = (await snapshot.ref.getDownloadURL()).toString();
      return url;
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
      return null;
    }
  }

  static List<String> othersUID(List<String> usersValue) {
    List<String> myUsers = usersValue
        .where((String element) => element != AuthMethods.uid)
        .toList();
    return myUsers.isEmpty ? <String>[''] : myUsers;
  }
}
