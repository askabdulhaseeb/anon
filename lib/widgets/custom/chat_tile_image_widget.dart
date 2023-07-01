import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../functions/helping_funcation.dart';
import '../../models/chat/chat.dart';

class ChatTileImageWidget extends StatelessWidget {
  const ChatTileImageWidget(
    this.chat, {
    this.fit = BoxFit.cover,
    this.size = 22,
    super.key,
  });
  final Chat chat;
  final double size;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundColor: Color(chat.defaultColor),
      backgroundImage: chat.imageURL.isEmpty
          ? null
          : CachedNetworkImageProvider(chat.imageURL),
      child: chat.imageURL.isEmpty ? _placeholder() : null,
    );
  }

  Widget _placeholder() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FittedBox(
        child: Text(
          HelpingFuncation().photoPlaceholder(chat.title.toUpperCase()),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
