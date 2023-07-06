import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/firebase/auth_methods.dart';
import '../../../database/local/local_user.dart';
import '../../../enums/chat/message_type.dart';
import '../../../models/chat/message.dart';
import '../../../models/user/app_user.dart';
import '../../../providers/chat_provider.dart';
import 'announcement_message_widget.dart';
import 'message_media_attachment_widget.dart';
import 'reference_message_widget.dart';

class MessageTile extends StatelessWidget {
  const MessageTile(this.message, {super.key});
  final Message message;
  static const double _borderRadius = 12;

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.sendBy == AuthMethods.uid;
    Widget swipReply = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        'Swip to reply',
        style: TextStyle(
          color: Theme.of(context).disabledColor,
          fontSize: 11,
        ),
      ),
    );
    return message.type == MessageType.announcement
        ? AnnouncementMessageWidget(text: message.text)
        : GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) =>
                Provider.of<ChatProvider>(context, listen: false)
                    .onAttachedMessageUpdate(message),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (isMe) swipReply,
                ClipRRect(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(8),
                    constraints: BoxConstraints(
                      minWidth: 80,
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_borderRadius),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(1, 1),
                        ),
                      ],
                      color: isMe
                          ? Colors.grey[100]
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (AuthMethods.uid != message.sendBy)
                          FutureBuilder<AppUser>(
                            future: LocalUser().user(message.sendBy),
                            builder: (BuildContext context,
                                AsyncSnapshot<AppUser> snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data?.name ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(snapshot.data?.defaultColor ??
                                        Colors.grey.value),
                                  ),
                                );
                              } else {
                                return Container(
                                  width: 50,
                                  height: 10,
                                  color: Colors.grey,
                                );
                              }
                            },
                          ),
                        if (message.replyOf != null)
                          ReferenceMessageWidget(message: message.replyOf!),
                        if (message.attachment.isNotEmpty)
                          MessageMediaAttachmentWidget(message: message),
                        if (message.text.isNotEmpty) Text(message.text),
                      ],
                    ),
                  ),
                ),
                if (!isMe) swipReply,
              ],
            ),
          );
  }
}
