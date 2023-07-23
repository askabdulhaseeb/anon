import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../database/firebase/board/task_card_api.dart';
import '../../../database/local/board/local_task_card.dart';
import '../../../enums/attachment_type.dart';
import '../../../functions/picker_functions.dart';
import '../../../models/board/task_card.dart';
import '../../../models/project/attachment.dart';
import '../../custom/custom_network_image.dart';
import '../../custom/show_loading.dart';

class TaskCardDetailAppBar extends StatelessWidget {
  const TaskCardDetailAppBar(this.card, {super.key});
  final TaskCard card;

  @override
  Widget build(BuildContext context) {
    return card.coverURL == null || (card.coverURL?.isEmpty ?? true)
        ? Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 60),
                _Cover(card),
              ],
            ),
          )
        : Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1 / 1,
                child: CustomNetworkImage(imageURL: card.coverURL!),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _Cover(card, title: 'Update Cover'),
              ),
            ],
          );
  }
}

class _Cover extends StatefulWidget {
  const _Cover(this.card, {this.title = 'Add Cover'});
  final TaskCard card;
  final String title;

  @override
  State<_Cover> createState() => _CoverState();
}

class _CoverState extends State<_Cover> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: Theme.of(context).disabledColor),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: InkWell(
          onTap: () async {
            final File? file = await PickerFunctions().image();
            if (file == null) return;
            setState(() {
              isLoading = true;
            });
            final Attachment attach = Attachment(
              url: '',
              filePath: file.path,
              type: AttachmentType.photo,
              attachmentID: '',
              storagePath: '',
            );
            final List<Attachment> attachments =
                await TaskCardAPI().uploadAttachments(
              attachments: <Attachment>[attach],
              cardID: widget.card.cardID,
            );
            if (attachments.isEmpty) {
              setState(() {
                isLoading = false;
              });
              return;
            }
            widget.card.coverURL = attachments[0].url;
            widget.card.attachments.addAll(attachments);
            await LocalTaskCard().update(widget.card);
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: isLoading
                ? const SizedBox(width: 100, child: ShowLoading())
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(CupertinoIcons.collections),
                      const SizedBox(width: 8),
                      Text(widget.title, style: const TextStyle(fontSize: 20)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
