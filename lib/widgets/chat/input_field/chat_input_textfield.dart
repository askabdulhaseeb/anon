import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/chat/chat.dart';
import '../../../models/chat/message.dart';
import '../../../providers/chat_provider.dart';

import '../messages/attached_message.dart';
import 'attached_file_widget.dart';
import 'attachment_selection_widget.dart';

class ChatInputTextField extends StatelessWidget {
  const ChatInputTextField(this.chat, {this.attachedMessage, super.key});
  final Chat chat;
  final Message? attachedMessage;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: const BorderSide(color: Colors.grey),
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      color: Theme.of(context).dividerColor.withOpacity(0.5),
      child: Consumer<ChatProvider>(
          builder: (BuildContext context, ChatProvider chatPro, _) {
        final List<File> files = chatPro.files;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (chatPro.attachedMessage != null)
              AttachedMessage(chatPro.attachedMessage!),
            if (files.isNotEmpty)
              SizedBox(
                child: SizedBox(
                  height: 60,
                  child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: files.length,
                    itemBuilder: (BuildContext context, int index) =>
                        AttachedFileWidget(files[index]),
                  ),
                ),
              ),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    showBottomSheet(
                      context: context,
                      elevation: 10,
                      builder: (BuildContext context) =>
                          AttachmentSelectionWidget(
                        onTap: (List<File> value) =>
                            chatPro.onFileUpdate(value),
                      ),
                    );
                  },
                  splashRadius: 16,
                  icon: const RotationTransition(
                    turns: AlwaysStoppedAnimation<double>(45 / 360),
                    child: Icon(Icons.attachment_rounded),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: chatPro.text,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: 5,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
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
                  onPressed: () async =>
                      await chatPro.onSendMessage(chat: chat),
                  splashRadius: 16,
                  icon: const CircleAvatar(
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
            const Center(
              child: Text(
                '''Please don't share your personal info here''',
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        );
      }),
    );
  }
}
