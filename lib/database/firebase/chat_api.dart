import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../enums/chat/message_type.dart';
import '../../enums/user/user_type.dart';
import '../../models/chat/chat.dart';
import '../../models/chat/message.dart';
import '../../models/chat/message_read_info.dart';
import '../../models/project/attachment.dart';
import '../../models/user/app_user.dart';
import '../../models/user/number_detail.dart';
import '../../widgets/custom/custom_toast.dart';
import '../local/local_chat.dart';
import 'auth_methods.dart';
import 'message_api.dart';

class ChatAPI {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  static const String _collection = 'chats';

  Stream<List<Chat>> chats(String projectID) {
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
      if (chats.isNotEmpty) {
        LocalChat().addAllChat(chats);
      }
      return chats;
    });
  }

  Future<void> chatsReferesh(String projectID) async {
    final List<Chat> results = <Chat>[];
    try {
      final QuerySnapshot<Map<String, dynamic>> doc = await _instance
          .collection(_collection)
          .where('persons', arrayContains: AuthMethods.uid)
          .where('project_id', isEqualTo: projectID)
          .orderBy('timestamp', descending: true)
          .get();
      if (doc.docs.isEmpty) return;
      for (DocumentSnapshot<Map<String, dynamic>> element in doc.docs) {
        final Chat temp = Chat.fromMap(element.data()!);
        results.add(temp);
      }
      if (results.isNotEmpty) {
        await LocalChat().addAllChat(results);
      }
    } catch (e) {}
    //     .asyncMap((QuerySnapshot<Map<String, dynamic>> event) {
    //   List<Chat> chats = <Chat>[];
    //   for (DocumentSnapshot<Map<String, dynamic>> element in event.docs) {
    //     final Chat temp = Chat.fromMap(element.data()!);
    //     chats.add(temp);
    //   }
    //   if (chats.isNotEmpty) {
    //     LocalChat().addAllChat(chats);
    //   }
    //   return chats;
    // });
  }

  Future<void> startChat({
    required Chat newChat,
    required List<AppUser> receiver,
    required AppUser? sender,
  }) async {
    await _instance
        .collection(_collection)
        .doc(newChat.chatID)
        .set(newChat.toMap());
    if (newChat.lastMessage != null) {
      final Message msg = Message(
        chatID: newChat.chatID,
        projectID: newChat.projectID,
        type: MessageType.announcement,
        attachment: <Attachment>[],
        sendTo: <MessageReadInfo>[],
        sendToUIDs: <String>[],
        text: '',
        displayString: 'Created New Chat',
      );
      await MessageAPI().sendMessage(
        newMessage: newChat.lastMessage ?? msg,
        receiver: receiver,
        sender: sender ??
            AppUser(
              uid: '',
              agencyIDs: <String>[],
              name: '',
              phoneNumber: NumberDetails(
                  countryCode: '', number: '', completeNumber: '', isoCode: ''),
              email: '',
              password: '',
              type: UserType.user,
            ),
      );
    }
  }

  Future<void> updateMembers(Chat value) async {
    try {
      await _instance
          .collection(_collection)
          .doc(value.chatID)
          .update(value.toAddMember());
      // await _instance
      //     .collection(_collection)
      //     .doc(chat.chatID)
      //     .collection(_messageCollection)
      //     .doc(newMessage.messageID)
      //     .set(newMessage.toMap());
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
  }

  Future<Chat?> chat(String chatID) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _instance.collection(_collection).doc(chatID).get();
    if (!doc.exists) return null;
    return Chat.fromMap(doc.data()!);
  }

  Future<String?> uploadChatLogo({
    required File file,
    required String chatID,
  }) async {
    try {
      String tempPath = '$_collection/$chatID/$chatID}';
      TaskSnapshot snapshot =
          await FirebaseStorage.instance.ref(tempPath).putFile(file);
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
