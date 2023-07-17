import 'package:flutter/material.dart';

import '../../../models/board/task_list.dart';

class AddTaskCardWidget extends StatelessWidget {
  const AddTaskCardWidget(this.list, {super.key});
  final TaskList list;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: <Widget>[
          Icon(Icons.add, color: Colors.grey, size: 20),
          Text(' Add a cards'),
        ],
      ),
    );
  }
}
