import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/project/attachment.dart';
import '../../../providers/chat_provider.dart';

class AttachedFileWidget extends StatelessWidget {
  const AttachedFileWidget(this.attachment, {super.key});
  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Center(child: Image.file(File(attachment.filePath!))),
          GestureDetector(
            onTap: () => Provider.of<ChatProvider>(context, listen: false)
                .onFileRemove(attachment),
            child: Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Theme.of(context).primaryColor,
              ),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
