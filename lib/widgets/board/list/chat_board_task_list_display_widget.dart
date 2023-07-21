import 'package:flutter/material.dart';

import '../../../database/firebase/board/board_api.dart';
import '../../../database/local/board/local_board.dart';
import '../../../database/local/board/local_task_list.dart';
import '../../../database/local/local_project.dart';
import '../../../models/board/board.dart';
import '../../../models/board/task_list.dart';
import '../../../models/project/project.dart';
import '../../../views/board_screens/board/board_screen.dart';

class ChatBoardTaskListDisplayWidget extends StatefulWidget {
  const ChatBoardTaskListDisplayWidget(this.projectID, {super.key});
  final String projectID;

  @override
  State<ChatBoardTaskListDisplayWidget> createState() =>
      _ChatBoardTaskListDisplayWidgetState();
}

class _ChatBoardTaskListDisplayWidgetState
    extends State<ChatBoardTaskListDisplayWidget> {
  final bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Board?>(
      future: LocalBoard().boardByProjectID(widget.projectID),
      builder: (BuildContext context, AsyncSnapshot<Board?> boardSnap) {
        if (boardSnap.connectionState == ConnectionState.done) {
          final Board? board = boardSnap.data;
          return board == null
              ? TextButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          isLoading == true;
                          final Project pro =
                              await LocalProject().project(widget.projectID);
                          if (pro.pid != widget.projectID) return;
                          await BoardAPI().createProjectBoard(pro);
                          setState(() {
                            isLoading == false;
                          });
                        },
                  child: const Text('Create New Board'),
                )
              : FutureBuilder<List<TaskList>>(
                  future: LocalTaskList().listByBoardID(board.boardID),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<List<TaskList>> snapshot,
                  ) {
                    final List<TaskList> lists = snapshot.data ?? <TaskList>[];
                    return lists.isEmpty
                        ? TextButton(
                            onPressed: () => Navigator.of(context).pushNamed(
                                BoardScreen.routeName,
                                arguments: board.boardID),
                            child: const Text('View Full Board'),
                          )
                        : SizedBox(
                            height: 34,
                            width: double.infinity,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: lists.length,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            _ListCard(lists[index]),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(BoardScreen.routeName,
                                          arguments: board.boardID),
                                  child: const Text('View Full Board'),
                                ),
                              ],
                            ),
                          );
                  },
                );
        } else {
          return const Text('Loading...');
        }
      },
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard(this.list, {this.boardColor});
  final TaskList list;
  final Color? boardColor;

  @override
  Widget build(BuildContext context) {
    final Color color =
        boardColor ?? Theme.of(context).textTheme.bodyMedium!.color!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        list.title,
        style: TextStyle(color: color),
      ),
    );
  }
}
