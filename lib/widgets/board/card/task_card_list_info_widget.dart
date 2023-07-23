import 'package:flutter/material.dart';

import '../../../database/local/board/local_task_list.dart';
import '../../../models/board/task_card.dart';
import '../../../models/board/task_list.dart';

class TaskCardListInfoWidget extends StatelessWidget {
  const TaskCardListInfoWidget({required this.card, super.key});

  final TaskCard card;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FutureBuilder<TaskList?>(
        future: LocalTaskList().listByListID(card.listID),
        builder: (BuildContext context, AsyncSnapshot<TaskList?> snapshot) {
          return RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall,
              children: <TextSpan>[
                const TextSpan(text: ' In list: '),
                TextSpan(
                  text: snapshot.data?.title ?? 'null',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
