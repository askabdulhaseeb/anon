import 'package:flutter/material.dart';

import '../../../database/firebase/auth_methods.dart';
import '../../../database/local/local_message.dart';
import '../../../database/local/local_user.dart';
import '../../../models/chat/message.dart';
import '../../../models/user/app_user.dart';
import '../../custom/custom_network_image.dart';

class ReferenceMessageWidget extends StatelessWidget {
  const ReferenceMessageWidget({
    required this.messageID,
    required this.chatID,
    super.key,
  });
  final String messageID;
  final String chatID;

  @override
  Widget build(BuildContext context) {
    const TextStyle nameText = TextStyle(fontWeight: FontWeight.bold);
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: FutureBuilder<Message>(
          future: LocalMessage().message(chatID, messageID),
          builder: (BuildContext context, AsyncSnapshot<Message> snapshot) {
            if (snapshot.hasData) {
              final Message message = snapshot.data!;
              return Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        message.sendBy == AuthMethods.uid
                            ? const Text('You', style: nameText)
                            : FutureBuilder<AppUser>(
                                future: LocalUser().user(message.sendBy),
                                builder: (BuildContext context,
                                    AsyncSnapshot<AppUser> snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data?.name ?? '',
                                      style: nameText,
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
                        Text(
                          message.displayString,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (message.attachment.isNotEmpty) const SizedBox(width: 10),
                  if (message.attachment.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomNetworkImage(
                        imageURL: message.attachment[0].url,
                        size: 48,
                      ),
                    ),
                ],
              );
            } else {
              return const Text('loading...');
            }
          }),
    );
  }
}
