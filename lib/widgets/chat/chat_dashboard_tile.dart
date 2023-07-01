import 'package:flutter/material.dart';

import '../../database/firebase/auth_methods.dart';
import '../../database/local/local_message.dart';
import '../../functions/time_functions.dart';
import '../../models/chat/chat.dart';
import '../../models/chat/message.dart';
import '../../models/chat/message_read_info.dart';
import '../../views/chat_screens/chat_screen.dart';
import '../custom/chat_tile_image_widget.dart';

class ChatDashboardTile extends StatelessWidget {
  const ChatDashboardTile(this.chat, {super.key});
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ChatScreen.routeName, arguments: chat.chatID);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: ChatTileImageWidget(chat),
      title: Text(
        chat.title,
        maxLines: 1,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: FutureBuilder<Message>(
        future: LocalMessage().lastMessage(chat.chatID),
        builder: (BuildContext context, AsyncSnapshot<Message> snapshot) {
          if (snapshot.hasData) {
            final Message? msg = snapshot.data;
            return Text(
              msg?.displayString ?? 'Message issue',
              style: const TextStyle(color: Colors.grey),
            );
          } else {
            return const Text('');
          }
        },
      ),
      trailing: FutureBuilder<Message>(
        future: LocalMessage().lastMessage(chat.chatID),
        builder: (BuildContext context, AsyncSnapshot<Message> snapshot) {
          if (snapshot.hasData) {
            final Message? msg = snapshot.data;
            final String me = AuthMethods.uid;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(TimeFun.timeInWords(msg?.timestamp)),
                if ((msg?.sendBy ?? '') == me &&
                    msg?.sendTo
                            .firstWhere(
                              (MessageReadInfo e) => e.uid == me,
                              orElse: () => MessageReadInfo(uid: ''),
                            )
                            .seen ==
                        false)
                  Icon(Icons.circle, color: Theme.of(context).primaryColor)
              ],
            );
          } else {
            return const Text('');
          }
        },
      ),
      // Text(TimeFun.timeInWords(chat.timestamp)),
    );
  }
}
