import 'dart:io';
import 'package:flutter/material.dart';

import '../../../enums/chat/chat_attachment_option.dart';
import '../../../functions/picker_functions.dart';

class AttachmentSelectionWidget extends StatelessWidget {
  const AttachmentSelectionWidget({required this.onTap, super.key});
  final void Function(List<File> files) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _AttachmentWidget(
                ChatAttachmentOption.camera,
                onTap: () async {
                  final File? results = await PickerFunctions().camera();
                  if (results == null) return;
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(results);
                  onTap(<File>[results]);
                },
              ),
              _AttachmentWidget(
                ChatAttachmentOption.gallery,
                onTap: () async {
                  final List<File> results = await PickerFunctions().images();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(results);
                  onTap(results);
                },
              ),
              _AttachmentWidget(
                ChatAttachmentOption.document,
                onTap: () async {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AttachmentWidget extends StatelessWidget {
  const _AttachmentWidget(this.attachment, {required this.onTap});
  final ChatAttachmentOption attachment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: attachment.bgColor,
            ),
            child: SizedBox(
              height: 30,
              width: 30,
              child: Image.asset(attachment.path),
            ),
          ),
          const SizedBox(height: 4),
          Text(attachment.title)
        ],
      ),
    );
  }
}
