import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/firebase/auth_methods.dart';
import '../../../enums/attachment_type.dart';
import '../../../models/chat/chat.dart';
import '../../../models/chat/message.dart';
import '../../../models/project/attachment.dart';
import '../../../providers/chat_provider.dart';

import '../../custom/show_loading.dart';
import '../messages/attached_message.dart';
import 'attached_file_widget.dart';
import 'attachment_selection_widget.dart';

class ChatInputTextField extends StatelessWidget {
  const ChatInputTextField(this.chat, {this.attachedMessage, super.key});
  final Chat chat;
  final Message? attachedMessage;

  @override
  Widget build(BuildContext context) {
    final String me = AuthMethods.uid;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Consumer<ChatProvider>(
          builder: (BuildContext context, ChatProvider chatPro, _) {
        final List<Attachment> attachments = chatPro.attachments;
        return chat.persons.contains(me)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (chatPro.attachedMessage != null)
                    AttachedMessage(chatPro.attachedMessage!),
                  if (attachments.isNotEmpty)
                    SizedBox(
                      child: SizedBox(
                        height: 60,
                        child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: attachments.length,
                          itemBuilder: (BuildContext context, int index) =>
                              AttachedFileWidget(attachments[index]),
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
                              onTap: (List<File> value, AttachmentType type) =>
                                  chatPro.onFileUpdate(value, type: type),
                            ),
                          );
                        },
                        splashRadius: 16,
                        icon: Icon(
                          Icons.add_box_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: chatPro.text,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          maxLines: 5,
                          minLines: 1,
                          readOnly: chatPro.isSendingMessage,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (_) async =>
                              await chatPro.updateUnseendMessages(chat.chatID),
                          decoration: const InputDecoration(
                            hintText: 'Write message here...',
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 12,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async => chatPro.isSendingMessage
                            ? null
                            : await chatPro.onSendMessage(chat: chat),
                        splashRadius: 16,
                        icon: chatPro.isSendingMessage
                            ? const ShowLoading()
                            : const CircleAvatar(
                                child: Icon(Icons.send, color: Colors.white),
                              ),
                      ),
                    ],
                  ),
                ],
              )
            : Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: const Text('You are no longer a member of this chat'),
              );
      }),
    );
  }
}
