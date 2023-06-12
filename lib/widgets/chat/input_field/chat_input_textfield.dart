import 'package:flutter/material.dart';

import '../../../database/firebase/auth_methods.dart';
import '../../../database/firebase/chat_api.dart';
import '../../../database/local/local_chat.dart';
import '../../../database/local/local_message.dart';
import '../../../database/local/local_user.dart';
import '../../../enums/chat/message_type.dart';
import '../../../models/chat/chat.dart';
import '../../../models/chat/message.dart';
import '../../../models/chat/message_read_info.dart';
import '../../../models/project/attachment.dart';
import '../../../models/user/app_user.dart';

class ChatInputTextField extends StatefulWidget {
  const ChatInputTextField(this.chat, {super.key});
  final Chat chat;

  @override
  State<ChatInputTextField> createState() => _ChatInputTextFieldState();
}

class _ChatInputTextFieldState extends State<ChatInputTextField> {
  final TextEditingController _text = TextEditingController();
  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: const BorderSide(color: Colors.grey),
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      color: Theme.of(context).dividerColor.withOpacity(0.5),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {},
            splashRadius: 16,
            icon: const Icon(Icons.attachment_rounded),
          ),
          Expanded(
            child: TextFormField(
              controller: _text,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Write message here...',
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 12,
                ),
                focusedBorder: outlineInputBorder,
                border: outlineInputBorder,
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              final String me = AuthMethods.uid;
              final Message msg = Message(
                chatID: widget.chat.chatID,
                type: MessageType.text,
                attachment: <Attachment>[],
                sendTo: widget.chat.persons
                    .map((String e) => MessageReadInfo(uid: e))
                    .toList(),
                sendToUIDs: widget.chat.persons,
                text: _text.text.trim(),
                displayString: _text.text.trim(),
              );
              widget.chat.lastMessage = msg;
              await LocalMessage().addMessage(msg);
              await LocalChat().addChat(widget.chat);
              _text.clear();
              final AppUser sender = await LocalUser().user(me);
              final List<String> stringUID = widget.chat.persons
                  .where((String element) => element != me)
                  .toList();
              final List<AppUser> receiver =
                  await LocalUser().stringListToObjectList(stringUID);
              ChatAPI().sendMessage(
                chat: widget.chat,
                receiver: receiver,
                sender: sender,
              );
            },
            splashRadius: 16,
            icon: const CircleAvatar(
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
