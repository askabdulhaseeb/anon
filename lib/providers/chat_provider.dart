import 'dart:io';
import 'package:flutter/cupertino.dart';

import '../database/firebase/auth_methods.dart';
import '../database/firebase/message_api.dart';
import '../database/local/local_chat.dart';
import '../database/local/local_message.dart';
import '../database/local/local_user.dart';
import '../enums/attachment_type.dart';
import '../enums/chat/message_type.dart';
import '../models/chat/chat.dart';
import '../models/chat/message.dart';
import '../models/chat/message_read_info.dart';
import '../models/project/attachment.dart';
import '../models/user/app_user.dart';

class ChatProvider extends ChangeNotifier {
  onSendMessage({required Chat chat}) async {
    if (_text.text.trim().isEmpty && _attachments.isEmpty) return;
    _onLoading(true);
    final String me = AuthMethods.uid;
    final String displayMsg = _text.text.trim().isNotEmpty
        ? _text.text.replaceAll('\n', ' ').trim()
        : _attachments[0].type == AttachmentType.photo
            ? '📸 Photo'
            : _attachments[0].type == AttachmentType.video
                ? '📹 Video'
                : _attachments[0].type == AttachmentType.audio
                    ? '🎤 Audio'
                    : _attachments[0].type == AttachmentType.document
                        ? '📄 Document'
                        : 'Send an Attachment 📌';
    final Message msg = Message(
      chatID: chat.chatID,
      projectID: chat.projectID,
      type: MessageType.text,
      attachment: _attachments.toList(),
      sendTo: chat.persons
          .map((String e) => MessageReadInfo(uid: e, seen: e == me))
          .toList(),
      sendToUIDs: chat.persons,
      text: _text.text.trim(),
      displayString: displayMsg,
      replyOf: _attachedMessage,
    );
    await LocalMessage().addMessage(msg);
    reset();
    //
    // Uploading on firebase
    if (msg.attachment.isNotEmpty) {
      final List<Attachment> cloudAttachments = await MessageAPI()
          .uploadAttachments(attachments: msg.attachment, chatID: chat.chatID);
      msg.attachment.clear();
      msg.attachment.addAll(cloudAttachments);
    }
    chat.lastMessage = msg;
    await LocalMessage().addMessage(msg);
    await LocalChat().addChat(chat);
    final AppUser sender = await LocalUser().user(me);
    final List<String> stringUID =
        chat.persons.where((String element) => element != me).toList();
    final List<AppUser> receiver =
        await LocalUser().stringListToObjectList(stringUID);
    await MessageAPI().sendMessage(
      newMessage: msg,
      receiver: receiver,
      sender: sender,
    );
  }

  Future<void> updateUnseendMessages(String chatID) async {
    await LocalMessage().updateSeenByMe(chatID);
  }

  void reset() {
    _attachedMessage = null;
    _attachments.clear();
    _text.clear();
    _onLoading(false);
  }

  void onAttachedMessageUpdate(Message? value) async {
    _attachedMessage = value;
    notifyListeners();
  }

  void onFileUpdate(List<File> values, {required AttachmentType type}) {
    if (values.isEmpty) return;
    for (int i = _attachments.length, j = 0;
        i < 10 && j < values.length;
        i++, j++) {
      _attachments.add(
        Attachment(
          url: '',
          type: type,
          attachmentID: '$i',
          storagePath: values[i].path,
          localStoragePath: values[0].path,
          filePath: values[i].path,
        ),
      );
      notifyListeners();
    }
  }

  void onFileRemove(Attachment value) {
    _attachments.remove(value);
    notifyListeners();
  }

  void _onLoading(bool value) {
    _isSendingMessage = value;
    notifyListeners();
  }

  bool get isSendingMessage => _isSendingMessage;
  Message? get attachedMessage => _attachedMessage;
  List<Attachment> get attachments => _attachments;
  TextEditingController get text => _text;

  bool _isSendingMessage = false;
  Message? _attachedMessage;
  final List<Attachment> _attachments = <Attachment>[];
  final TextEditingController _text = TextEditingController();
}
