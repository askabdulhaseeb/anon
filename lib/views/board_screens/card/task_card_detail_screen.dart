import 'package:flutter/material.dart';

import '../../../database/local/board/local_task_card.dart';
import '../../../database/local/board/local_task_list.dart';
import '../../../models/board/check_list.dart';
import '../../../models/board/task_card.dart';
import '../../../models/board/task_list.dart';
import '../../../widgets/board/card/checklist/checklist_item_widget.dart';
import '../../../widgets/board/card/checklist/start_new_checklist_widget.dart';
import '../../../widgets/custom/parsed_text_widget.dart';
import '../../../widgets/custom/show_loading.dart';

class TaskCardDetailScreen extends StatefulWidget {
  const TaskCardDetailScreen({Key? key}) : super(key: key);
  static const String routeName = '/task-card-detail';

  @override
  State<TaskCardDetailScreen> createState() => _TaskCardDetailScreenState();
}

class _TaskCardDetailScreenState extends State<TaskCardDetailScreen> {
  bool needUpdate = false;
  late TaskCard? card;

  @override
  Widget build(BuildContext context) {
    final String cardID = ModalRoute.of(context)!.settings.arguments as String;
    return WillPopScope(
      onWillPop: () async {
        if (!needUpdate) return true;
        await LocalTaskCard().update(card!);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: const <Widget>[
            Icon(Icons.person_add_alt_1_outlined),
          ],
        ),
        body: FutureBuilder<TaskCard?>(
          future: LocalTaskCard().cardsByCardID(cardID),
          builder: (BuildContext context, AsyncSnapshot<TaskCard?> cardSnap) {
            if (cardSnap.connectionState == ConnectionState.done) {
              card = cardSnap.data;
              return card == null
                  ? const Center(child: Text('ERROR'))
                  : SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              card!.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            FutureBuilder<TaskList?>(
                              future:
                                  LocalTaskList().listByListID(card!.listID),
                              builder: (BuildContext context,
                                  AsyncSnapshot<TaskList?> snapshot) {
                                return RichText(
                                  text: TextSpan(
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
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
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade200,
                              ),
                              child: ParsedTextWidget(card!.description),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () async {
                                  final CheckList? checklist = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        StartNewChecklistWidget(
                                      cardID: cardID,
                                      position: card!.checklists.length,
                                    ),
                                  );
                                  if (checklist == null) return;
                                  setState(() {
                                    card!.checklists.add(checklist);
                                  });
                                  await LocalTaskCard().update(card!);
                                },
                                icon:
                                    const Icon(Icons.playlist_add_check_sharp),
                                label: const Text('Add Checklist'),
                              ),
                            ),
                            Column(
                              children: card!.checklists
                                  .map(
                                    (CheckList e) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          e.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ListView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: e.items.length,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              CheckListItemWidget(
                                            e.items[index],
                                            onTap: () {
                                              needUpdate = true;
                                              setState(() {
                                                e.items[index].isChecked =
                                                    !e.items[index].isChecked;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    );
            } else {
              return const ShowLoading();
            }
          },
        ),
      ),
    );
  }
}
