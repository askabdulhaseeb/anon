import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../models/board/check_item.dart';
import '../../../../models/board/check_list.dart';
import '../../../../models/board/task_card.dart';
import '../../../custom/custom_textformfield.dart';
import 'checklist_item_widget.dart';

class ChecklistListsDisplayWidget extends StatefulWidget {
  const ChecklistListsDisplayWidget(this.card,
      {required this.onChange, super.key});
  final TaskCard card;
  final void Function(CheckList, CheckItem, DocumentChangeType type) onChange;

  @override
  State<ChecklistListsDisplayWidget> createState() =>
      _ChecklistListsDisplayWidgetState();
}

class _ChecklistListsDisplayWidgetState
    extends State<ChecklistListsDisplayWidget> {
  final TextEditingController _newCheckItem = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: widget.card.checklists
            .map(
              (CheckList e) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          e.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.playlist_add_check_sharp,
                        size: 20,
                        color: Theme.of(context).disabledColor,
                      ),
                      Text(
                        '${e.items.where((CheckItem element) => element.isChecked).length}/${e.items.length}',
                        style:
                            TextStyle(color: Theme.of(context).disabledColor),
                      )
                    ],
                  ),
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: e.items.length,
                    itemBuilder: (BuildContext context, int index) =>
                        CheckListItemWidget(
                      e.items[index],
                      onTap: () {
                        setState(() {
                          e.items[index].isChecked = !e.items[index].isChecked;
                        });
                        widget.onChange(
                            e, e.items[index], DocumentChangeType.modified);
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: CustomTextFormField(
                        controller: _newCheckItem,
                        hint: 'write task here...',
                        showSuffixIcon: false,
                      )),
                      TextButton(
                        onPressed: () async {
                          if (_newCheckItem.text.isEmpty) {
                            return;
                          }
                          final CheckItem newItem = CheckItem(
                            text: _newCheckItem.text.trim(),
                            position: e.items.length,
                          );
                          setState(() {
                            e.items.add(newItem);
                          });
                          _newCheckItem.clear();
                          widget.onChange(e, newItem, DocumentChangeType.added);
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
