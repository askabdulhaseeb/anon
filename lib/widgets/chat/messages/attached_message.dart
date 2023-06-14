import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/local/local_user.dart';
import '../../../models/chat/message.dart';
import '../../../models/user/app_user.dart';
import '../../../providers/chat_provider.dart';
import '../../custom/custom_network_image.dart';
import '../../custom/show_loading.dart';

class AttachedMessage extends StatelessWidget {
  const AttachedMessage(this.message, {super.key});
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FutureBuilder<AppUser>(
                    future: LocalUser().user(message.sendBy),
                    builder: (BuildContext context,
                        AsyncSnapshot<AppUser> snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data?.name ?? 'null',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        );
                      } else {
                        return const ShowLoading();
                      }
                    },
                  ),
                  Text(
                    message.displayString,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          if (message.attachment.isNotEmpty)
            CustomNetworkImage(imageURL: message.attachment[0].url, size: 40),
          IconButton(
            onPressed: () => Provider.of<ChatProvider>(context, listen: false)
                .onAttachedMessageUpdate(null),
            splashRadius: 16,
            icon: const Icon(CupertinoIcons.clear_circled, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
