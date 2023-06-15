import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../database/firebase/auth_methods.dart';
import '../database/firebase/message_api.dart';
import '../database/local/local_chat.dart';
import '../database/local/local_message.dart';
import '../database/local/local_user.dart';
import '../enums/attachment_type.dart';
import '../enums/chat/message_type.dart';
import '../functions/unique_id_fun.dart';
import '../models/chat/chat.dart';
import '../models/chat/message.dart';
import '../models/chat/message_read_info.dart';
import '../models/project/attachment.dart';
import '../models/user/app_user.dart';

class ChatProvider extends ChangeNotifier {
  onSendMessage({required Chat chat}) async {
    if (_text.text.trim().isEmpty && files.isEmpty) return;
    final String me = AuthMethods.uid;
    final List<Attachment> urls = <Attachment>[];
    if (files.isNotEmpty) {
      for (File file in files) {
        final String id = UniqueIdFun.unique();
        final (String path, String? url) = await MessageAPI().uploadAttachment(
            file: file, chatID: chat.chatID, attachmentID: id);
        if (url != null) {
          urls.add(
            Attachment(
              url: url,
              type: AttachmentType.photo,
              attachmentID: id,
              storagePath: path,
            ),
          );
        }
      }
    }
    final String displayMsg = _text.text.trim().isNotEmpty
        ? _text.text.trim()
        : urls[0].type == AttachmentType.photo
            ? '📸 Photo'
            : urls[0].type == AttachmentType.video
                ? '📹 Video'
                : urls[0].type == AttachmentType.audio
                    ? '🎤 Audio'
                    : urls[0].type == AttachmentType.document
                        ? '📄 Document'
                        : 'Send an Attachment 📌';
    final Message msg = Message(
      chatID: chat.chatID,
      projectID: chat.projectID,
      type: MessageType.text,
      attachment: urls,
      sendTo: chat.persons.map((String e) => MessageReadInfo(uid: e)).toList(),
      sendToUIDs: chat.persons,
      text: _text.text.trim(),
      displayString: displayMsg,
      replyOf: _attachedMessage,
    );
    chat.lastMessage = msg;
    await LocalMessage().addMessage(msg);
    await LocalChat().addChat(chat);
    _text.clear();
    final AppUser sender = await LocalUser().user(me);
    final List<String> stringUID =
        chat.persons.where((String element) => element != me).toList();
    final List<AppUser> receiver =
        await LocalUser().stringListToObjectList(stringUID);
    MessageAPI().sendMessage(
      newMessage: msg,
      receiver: receiver,
      sender: sender,
    );
    reset();
  }

  void reset() {
    _attachedMessage = null;
    _text.clear();
    _files.clear();
    notifyListeners();
  }

  void onAttachedMessageUpdate(Message? value) async {
    _attachedMessage = value;
    notifyListeners();
  }

  void onFileUpdate(List<File> value) {
    if (value.isEmpty) return;
    for (int i = _files.length, j = 0; i < 25; i++, j++) {
      _files.add(value[j]);
      notifyListeners();
    }
  }

  void onFileRemove(File value) {
    _files.remove(value);
    notifyListeners();
  }

  Message? get attachedMessage => _attachedMessage;
  List<File> get files => _files;
  TextEditingController get text => _text;

  Message? _attachedMessage;
  final List<File> _files = <File>[];
  final TextEditingController _text = TextEditingController();
}
