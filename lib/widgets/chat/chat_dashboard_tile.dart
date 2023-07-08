import 'package:flutter/material.dart';

import '../../database/firebase/auth_methods.dart';
import '../../database/local/local_message.dart';
import '../../functions/time_functions.dart';
import '../../models/chat/chat.dart';
import '../../models/chat/message.dart';
import '../../views/chat_screens/chat_screen.dart';
import '../custom/chat_tile_image_widget.dart';
import '../user/multi_user_display_widget.dart';

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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(TimeFun.timeInWords(msg?.timestamp)),
                FutureBuilder<List<String>>(
                  future: LocalMessage().listOfChatUnseenMessages(chat.chatID),
                  builder: (BuildContext context,
                          AsyncSnapshot<List<String>> snapshot) =>
                      MultiUserDisplayWidget(
                    snapshot.data ?? <String>[],
                    maxWidth: 80.0,
                  ),
                )
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
