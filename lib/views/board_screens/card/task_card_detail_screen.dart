import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../database/local/board/local_task_card.dart';
import '../../../database/local/board/local_task_list.dart';
import '../../../models/board/check_item.dart';
import '../../../models/board/check_list.dart';
import '../../../models/board/task_card.dart';
import '../../../models/board/task_list.dart';
import '../../../widgets/board/card/checklist/checklist_lists_display_widget.dart';
import '../../../widgets/board/card/checklist/start_new_checklist_widget.dart';
import '../../../widgets/custom/custom_textformfield.dart';
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
  late TextEditingController _title;
  late TextEditingController _des;

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
        appBar: AppBar(),
        body: FutureBuilder<TaskCard?>(
          future: LocalTaskCard().cardsByCardID(cardID),
          builder: (BuildContext context, AsyncSnapshot<TaskCard?> cardSnap) {
            if (cardSnap.connectionState == ConnectionState.done) {
              card = cardSnap.data;
              _title = TextEditingController(text: card?.title ?? 'null');
              _des = TextEditingController(text: card?.description ?? 'null');
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
                            CustomTextFormField(
                              controller: _title,
                              showSuffixIcon: false,
                              contentPadding: const EdgeInsets.all(0),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                              onChanged: (String p0) {
                                needUpdate = true;
                                card!.title = p0;
                              },
                              border: InputBorder.none,
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
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).disabledColor,
                              ),
                              child: CustomTextFormField(
                                controller: _des,
                                showSuffixIcon: false,
                                maxLines: 10,
                                onChanged: (String p0) {
                                  needUpdate = true;
                                  card!.description = p0;
                                },
                                border: InputBorder.none,
                              ),
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
                            ChecklistListsDisplayWidget(
                              card!,
                              onChange: (
                                CheckList v,
                                CheckItem item,
                                DocumentChangeType type,
                              ) =>
                                  onChange(v, item, type),
                            ),
                            const SizedBox(height: 200),
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

  onChange(CheckList v, CheckItem item, DocumentChangeType type) {
    needUpdate = true;
    if (type == DocumentChangeType.added) {
      card!.checklists
          .firstWhere(
              (CheckList element) => element.checkListID == v.checkListID)
          .items
          .toSet()
          .add(item);
    } else if (type == DocumentChangeType.modified) {
      card!.checklists
          .firstWhere(
              (CheckList element) => element.checkListID == v.checkListID)
          .items
          .firstWhere((CheckItem ele) => ele.id == item.id)
          .isChecked = item.isChecked;
    }
  }
}
