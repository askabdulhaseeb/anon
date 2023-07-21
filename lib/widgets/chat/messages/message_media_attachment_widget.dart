import 'dart:io';

import 'package:flutter/material.dart';

import '../../../enums/attachment_type.dart';
import '../../../models/chat/message.dart';
import '../../../views/chat_screens/message_media__full_screen.dart';
import '../../custom/custom_network_image.dart';
import '../../custom/custom_video_player.dart';
import '../../custom/show_loading.dart';

class MessageMediaAttachmentWidget extends StatelessWidget {
  const MessageMediaAttachmentWidget({required this.message, super.key});
  final Message message;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          MessageMediaFullScreen.routeName,
          arguments: message.attachment,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: message.attachment[0].isLive
                    ? message.attachment[0].type == AttachmentType.video
                        ? CustomVideoPlayer(path: message.attachment[0].url)
                        : CustomNetworkImage(
                            imageURL: message.attachment[0].url,
                            fit: BoxFit.cover,
                          )
                    : message.attachment[0].type == AttachmentType.video
                        ? CustomVideoPlayer(
                            path: message.attachment[0].localStoragePath,
                            isFileVideo: true)
                        : Image.file(
                            File(message.attachment[0].localStoragePath),
                            fit: BoxFit.cover,
                          ),
              ),
              if (!message.attachment[0].isLive)
                const Center(child: ShowLoading()),
              if (message.attachment.length > 1)
                Container(
                  color: Colors.black45,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${message.attachment.length - 1}+',
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Tap to view all',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
