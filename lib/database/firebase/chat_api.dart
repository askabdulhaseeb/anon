import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/chat/chat.dart';
import '../../models/chat/message.dart';
import '../../models/user/app_user.dart';
import '../../widgets/custom/custom_toast.dart';
import '../local/local_chat.dart';
import '../local/local_message.dart';
import 'auth_methods.dart';

class ChatAPI {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  static const String _chatCollection = 'chats';
  static const String _messageCollection = 'messages';

  Stream<List<Message>> messages(String chatID) {
    return _instance
        .collection(_chatCollection)
        .doc(chatID)
        .collection(_messageCollection)
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

  Future<Message?> message({
    required String chatID,
    required String messageID,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> doc = await _instance
        .collection(_chatCollection)
        .doc(chatID)
        .collection(_messageCollection)
        .doc(messageID)
        .get();
    if (doc.exists) return null;
    return Message.fromMap(doc.data()!);
  }

  Stream<List<Chat>> chats(String projectID) {
    // Firebase Index need to add
    // Composite Index
    // Collection ID -> chat
    // Field Indexed -> persons Arrays is_group Ascending timestamp Descending
    return _instance
        .collection(_chatCollection)
        .where('persons', arrayContains: AuthMethods.uid)
        .where('project_id', isEqualTo: projectID)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot<Map<String, dynamic>> event) {
      List<Chat> chats = <Chat>[];
      for (DocumentSnapshot<Map<String, dynamic>> element in event.docs) {
        final Chat temp = Chat.fromMap(element.data()!);
        chats.add(temp);
        LocalChat().addChat(temp);
      }
      return chats;
    });
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
            .collection(_chatCollection)
            .doc(chat.chatID)
            .collection(_messageCollection)
            .doc(newMessage.messageID)
            .set(newMessage.toMap());
      }
      await _instance
          .collection(_chatCollection)
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
  //           .collection(_chatCollection)
  //           .doc(chat.chatID)
  //           .update(chat.addMembers());
  //       await _instance
  //           .collection(_chatCollection)
  //           .doc(chat.chatID)
  //           .collection(_messageCollection)
  //           .doc(newMessage.messageID)
  //           .set(newMessage.toMap());
  //     }
  //   } catch (e) {
  //     CustomToast.errorToast(message: e.toString());
  //   }
  // }

  Future<Chat?> chat(String chatID) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _instance.collection(_chatCollection).doc(chatID).get();
    if (!doc.exists) return null;
    return Chat.fromMap(doc.data()!);
  }

  Future<(String path, String? url)> uploadAttachment({
    required File file,
    required String attachmentID,
  }) async {
    try {
      String tempPath = '$_chatCollection/projects/$attachmentID}';
      TaskSnapshot snapshot =
          await FirebaseStorage.instance.ref(tempPath).putFile(file);
      String url = (await snapshot.ref.getDownloadURL()).toString();
      return (tempPath, url);
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
      return ('', null);
    }
  }

  static List<String> othersUID(List<String> usersValue) {
    List<String> myUsers = usersValue
        .where((String element) => element != AuthMethods.uid)
        .toList();
    return myUsers.isEmpty ? <String>[''] : myUsers;
  }
}
