import 'package:flutter/material.dart';

import '../../../database/local/board/local_task_card.dart';
import '../../../models/board/task_card.dart';
import '../../../models/board/task_list.dart';
import '../../../utilities/utilities.dart';
import '../card/add_task_card_widget.dart';
import '../card/task_card_tile.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile(this.list, {super.key});
  final TaskList list;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Utilities.taskListWidth,
      constraints: const BoxConstraints(minHeight: 50),
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    list.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.adaptive.more),
                ),
              ],
            ),
            const Divider(thickness: 1),
            FutureBuilder<List<TaskCard>>(
              future: LocalTaskCard().cardsByListID(list.listID),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TaskCard>> snapshot) {
                final List<TaskCard> cards = snapshot.data ?? <TaskCard>[];
                return ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: cards.length,
                  itemBuilder: (_, int index) => TaskCardTile(cards[index]),
                );
              },
            ),
            AddTaskCardWidget(list),
          ],
        ),
      ),
    );
  }
}
