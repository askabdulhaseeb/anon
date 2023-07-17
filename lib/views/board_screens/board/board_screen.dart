import 'package:flutter/material.dart';

import '../../../database/local/board/local_board.dart';
import '../../../database/local/board/local_task_list.dart';
import '../../../models/board/board.dart';
import '../../../models/board/task_list.dart';
import '../../../widgets/board/list/add_task_list_widget.dart';
import '../../../widgets/board/list/task_list_tile.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({Key? key}) : super(key: key);
  static const String routeName = '/board';
  @override
  Widget build(BuildContext context) {
    final String boardID = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Board?>(
          future: LocalBoard().boardByBoardID(boardID),
          builder: (BuildContext context, AsyncSnapshot<Board?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final Board? board = snapshot.data;
              return Text(board?.title ?? 'null');
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
      body: FutureBuilder<List<TaskList>>(
        future: LocalTaskList().listByBoardID(boardID),
        builder:
            (BuildContext context, AsyncSnapshot<List<TaskList>> snapshot) {
          final List<TaskList> lists = snapshot.data ?? <TaskList>[];
          return lists.isEmpty
              ? AddTaskListWidget(boardID)
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: lists.length,
                  itemBuilder: (BuildContext context, int index) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (index == 0) const SizedBox(width: 20),
                      TaskListTile(lists[index]),
                      if (index == (lists.length - 1))
                        AddTaskListWidget(boardID),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
