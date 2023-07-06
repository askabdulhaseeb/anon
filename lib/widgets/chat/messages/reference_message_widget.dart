import 'package:flutter/material.dart';

import '../../../database/firebase/auth_methods.dart';
import '../../../database/local/local_user.dart';
import '../../../models/chat/message.dart';
import '../../../models/user/app_user.dart';
import '../../custom/custom_network_image.dart';

class ReferenceMessageWidget extends StatelessWidget {
  const ReferenceMessageWidget({required this.message, super.key});
  final Message message;

  @override
  Widget build(BuildContext context) {
    final TextStyle nameText = TextStyle(
        fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor);
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 4, top: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).dividerColor,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                message.sendBy == AuthMethods.uid
                    ? Text('You', style: nameText)
                    : FutureBuilder<AppUser>(
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
      ),
    );
  }
}
