import 'package:flutter/material.dart';

import '../../../../models/board/check_item.dart';

class CheckListItemWidget extends StatelessWidget {
  const CheckListItemWidget(
    this.item, {
    required this.onTap,
    super.key,
  });

  final CheckItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.all(0),
      leading: Icon(
          item.isChecked ? Icons.check_box : Icons.check_box_outline_blank),
      title: Text(
        item.text,
        style: TextStyle(
          decoration: item.isChecked ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }
}
