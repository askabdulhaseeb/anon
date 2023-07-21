import 'package:flutter/material.dart';

import '../../../database/firebase/board/task_card_api.dart';
import '../../../database/local/board/local_task_card.dart';
import '../../../models/board/task_card.dart';
import '../../../models/board/task_list.dart';
import '../../../utilities/custom_validators.dart';
import '../../custom/custom_elevated_button.dart';
import '../../custom/custom_textformfield.dart';

class AddTaskCardWidget extends StatefulWidget {
  const AddTaskCardWidget(this.list, {required this.onAdd, super.key});
  final TaskList list;
  final void Function(TaskCard) onAdd;

  @override
  State<AddTaskCardWidget> createState() => _AddTaskCardWidgetState();
}

class _AddTaskCardWidgetState extends State<AddTaskCardWidget> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _readyToAdd = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: _readyToAdd
          ? Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: <Widget>[
                  CustomTextFormField(
                    controller: _title,
                    autoFocus: true,
                    hint: 'Task Title',
                    validator: (String? value) =>
                        CustomValidator.isEmpty(value),
                  ),
                  CustomTextFormField(
                    controller: _description,
                    hint:
                        'Task Description\nExplain Task in detail to your team member',
                    readOnly: _isLoading,
                    validator: (_) => null,
                    maxLines: 7,
                    minLines: 4,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 140,
                        child: CustomElevatedButton(
                          title: 'Add Card',
                          isLoading: _isLoading,
                          onTap: onAdd,
                        ),
                      ),
                      if (!_isLoading)
                        IconButton(
                          onPressed: _reset,
                          splashRadius: 16,
                          icon: const Icon(Icons.clear),
                        ),
                    ],
                  )
                ],
              ),
            )
          : InkWell(
              onTap: () => setState(() {
                _readyToAdd = true;
              }),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.grey, size: 20),
                    Text(' Add new task'),
                  ],
                ),
              ),
            ),
    );
  }

  _reset() {
    _title.clear();
    _description.clear();
    setState(() {
      _readyToAdd = false;
      _isLoading = false;
    });
  }

  onAdd() async {
    if (!_key.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    final List<TaskCard> cards =
        await LocalTaskCard().cardsByListID(widget.list.listID);
    final TaskCard newCard = TaskCard(
      boardID: widget.list.boardID,
      listID: widget.list.listID,
      position: cards.length,
      title: _title.text,
      description: _description.text,
      projectID: widget.list.projectID,
    );
    await TaskCardAPI().create(newCard);
    widget.onAdd(newCard);
    _reset();
  }
}
