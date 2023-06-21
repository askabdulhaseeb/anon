import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/firebase/message_api.dart';
import '../../database/local/local_chat.dart';
import '../../models/chat/chat.dart';
import '../../models/chat/message.dart';
import '../../providers/chat_provider.dart';
import '../../utilities/app_images.dart';
import '../../widgets/chat/input_field/chat_input_textfield.dart';
import '../../widgets/chat/messages/messsage_tile.dart';
import '../../widgets/custom/custom_square_photo.dart';
import '../../widgets/custom/show_loading.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const String routeName = '/chat';
  @override
  Widget build(BuildContext context) {
    final String chatID = ModalRoute.of(context)!.settings.arguments as String;
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ChatProvider>(context, listen: false).reset();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(title: _AppBar(chatID: chatID)),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              image: const DecorationImage(
                image: AssetImage(AppImages.chatBGimage),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: StreamBuilder<List<Message>>(
                    stream: MessageAPI().messages(chatID),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<List<Message>> snapshot,
                    ) {
                      if (snapshot.hasData) {
                        final List<Message> messages =
                            snapshot.data ?? <Message>[];
                        return Container(
                          constraints: const BoxConstraints(minWidth: 100),
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            reverse: true,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: messages.length,
                            itemBuilder: (BuildContext context, int index) {
                              return MessageTile(messages[index]);
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('ERROR'));
                      } else {
                        return const ShowLoading();
                      }
                    },
                  ),
                ),
                SafeArea(
                  child: FutureBuilder<Chat>(
                    future: LocalChat().chat(chatID),
                    builder:
                        (BuildContext context, AsyncSnapshot<Chat> snapshot) {
                      if (snapshot.hasData) {
                        final Chat chat = snapshot.data!;
                        return ChatInputTextField(chat);
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('ERROR'));
                      } else {
                        return const ShowLoading();
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({required this.chatID});
  final String chatID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Chat>(
      future: LocalChat().chat(chatID),
      builder: (BuildContext context, AsyncSnapshot<Chat> snapshot) {
        if (snapshot.hasData) {
          final Chat chat = snapshot.data!;
          return GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(ChatDetailScreen.routeName, arguments: chatID),
            child: Row(
              children: <Widget>[
                CustomSquarePhoto(chat.imageURL, name: chat.title),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      chat.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Tap here to check details',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('ERROR'));
        } else {
          return const ShowLoading();
        }
      },
    );
  }
}
