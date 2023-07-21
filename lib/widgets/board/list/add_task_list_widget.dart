import 'package:flutter/material.dart';
import '../../../database/firebase/board/task_list_api.dart';
import '../../../database/local/board/local_board.dart';
import '../../../database/local/board/local_task_list.dart';
import '../../../models/board/board.dart';
import '../../../models/board/task_list.dart';
import '../../../utilities/custom_validators.dart';
import '../../../utilities/utilities.dart';
import '../../custom/custom_elevated_button.dart';
import '../../custom/custom_textformfield.dart';
import '../../custom/custom_toast.dart';

class AddTaskListWidget extends StatefulWidget {
  const AddTaskListWidget(this.boardID, {super.key});
  final String boardID;

  @override
  State<AddTaskListWidget> createState() => _AddTaskListWidgetState();
}

class _AddTaskListWidgetState extends State<AddTaskListWidget> {
  bool isAdding = false;
  bool isLoading = false;
  final TextEditingController _title = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Utilities.taskListWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.withOpacity(0.3),
      ),
      child: isAdding
          ? Form(
              key: _key,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: CustomTextFormField(
                      controller: _title,
                      hint: 'List Title',
                      autoFocus: true,
                      readOnly: isLoading,
                      showSuffixIcon: false,
                      validator: (String? p0) => CustomValidator.isEmpty(p0),
                    ),
                  ),
                  IconButton(
                    onPressed: rest,
                    icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                  ),
                  SizedBox(
                    width: 80,
                    child: CustomElevatedButton(
                      isLoading: isLoading,
                      onTap: onAdd,
                      title: 'Save',
                    ),
                  ),
                ],
              ),
            )
          : GestureDetector(
              onTap: () => setState(() {
                isAdding = true;
              }),
              child: const Row(
                children: <Widget>[
                  Icon(Icons.add, color: Colors.grey, size: 20),
                  Text(' Add a Task List'),
                ],
              ),
            ),
    );
  }

  rest() {
    _title.clear();
    setState(() {
      isAdding = false;
      isLoading = false;
    });
  }

  onAdd() async {
    if (!_key.currentState!.validate()) return;
    setState(() {
      isLoading = true;
    });
    final Board? board = await LocalBoard().boardByBoardID(widget.boardID);
    final List<TaskList> lists =
        await LocalTaskList().listByBoardID(widget.boardID);
    if (board == null) {
      if (!mounted) return;
      CustomToast.errorSnackBar(context, text: 'Something is wrong');
      return;
    }
    final TaskList list = TaskList(
      boardID: widget.boardID,
      title: _title.text,
      projectID: board.projectID,
      position: lists.length,
    );
    await TaskListAPI().create(list);
    rest();
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
