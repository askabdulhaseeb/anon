import 'package:flutter/material.dart';
import '../../../utilities/utilities.dart';

class AddTaskListWidget extends StatelessWidget {
  const AddTaskListWidget(this.boardID, {super.key});
  final String boardID;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Utilities.taskListWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: const Row(
        children: <Widget>[
          Icon(Icons.add, color: Colors.grey, size: 20),
          Text(' Add a Task List'),
        ],
      ),
    );
  }
}
