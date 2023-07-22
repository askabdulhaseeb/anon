import 'package:flutter/material.dart';

import '../../database/local/board/local_board.dart';
import '../../functions/time_functions.dart';
import '../../models/board/board.dart';
import '../board_screens/board/board_screen.dart';

class BoardsPage extends StatelessWidget {
  const BoardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            Text(
              'Work Boards',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
            const Divider(height: 16),
            FutureBuilder<List<Board>>(
              future: LocalBoard().boards(),
              builder: (BuildContext context, AsyncSnapshot<List<Board>> snap) {
                if (snap.hasError) return Text('Error - ${snap.error}');
                final List<Board> boards = snap.data ?? <Board>[];
                return boards.isEmpty
                    ? const Center(child: Text('No Board available'))
                    : ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: boards.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Board board = boards[index];
                          return ListTile(
                            title: Text(board.title),
                            subtitle: Text(
                              'Last Update: ${TimeFun.timeInWords(board.lastUpdate)}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  BoardScreen.routeName,
                                  arguments: board.boardID);
                            },
                          );
                        },
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}
