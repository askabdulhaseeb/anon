import 'dart:io';
import 'package:flutter/material.dart';

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
        ListTile(
          leading: const Icon(Icons.photo_library_outlined),
          title: const Text('Photos'),
          subtitle: const Text('Max. selection limit 25'),
          onTap: () async {
            final List<File> results = await PickerFunctions().images();
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop(results);
            onTap(results);
          },
        ),
        ListTile(
          enabled: false,
          leading: const Icon(Icons.video_collection_outlined),
          title: const Text('Videos'),
          subtitle: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Max. selection limit 25'),
              Text('Coming soon...', style: TextStyle(color: Colors.red)),
            ],
          ),
          onTap: () async {
            // TODO: video attachment left
            // final List<File> results = await PickerFunctions().videos();
            // // ignore: use_build_context_synchronously
            // Navigator.of(context).pop(results);
            // onTap(results);
          },
        ),
      ],
    );
  }
}
