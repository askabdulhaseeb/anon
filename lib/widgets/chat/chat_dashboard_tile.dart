import 'package:flutter/material.dart';

import '../../functions/time_functions.dart';
import '../../models/chat/chat.dart';
import '../../views/chat_screens/chat_screen.dart';
import '../custom/custom_profile_photo.dart';

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
      leading: CustomProfilePhoto(chat.imageURL, name: chat.title),
      title: Text(
        chat.title,
        maxLines: 1,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(chat.lastMessage?.displayString ?? ''),
      trailing: Text(TimeFun.timeInWords(chat.timestamp)),
    );
  }
}
