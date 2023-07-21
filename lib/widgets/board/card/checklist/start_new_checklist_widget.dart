import 'package:flutter/material.dart';

import '../../../../models/board/check_item.dart';
import '../../../../models/board/check_list.dart';
import '../../../../utilities/custom_validators.dart';
import '../../../custom/custom_textformfield.dart';
import 'checklist_item_widget.dart';

class StartNewChecklistWidget extends StatefulWidget {
  const StartNewChecklistWidget({
    required this.cardID,
    required this.position,
    super.key,
  });
  final String cardID;
  final int position;

  @override
  State<StartNewChecklistWidget> createState() =>
      _StartNewChecklistWidgetState();
}

class _StartNewChecklistWidgetState extends State<StartNewChecklistWidget> {
  final TextEditingController _title = TextEditingController(text: 'Checklist');
  final TextEditingController _text = TextEditingController();
  CheckList? checklist;

  @override
  void dispose() {
    _title.dispose();
    _text.dispose();
    super.dispose();
  }

  @override
  void initState() {
    checklist = CheckList(
        cardID: widget.cardID, title: _title.text, position: widget.position);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(null),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const Text(
                      'New Checklist',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(checklist),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
              const Text('Checlist Title'),
              CustomTextFormField(
                controller: _title,
                showSuffixIcon: false,
                autoFocus: true,
                hint: 'Checklist title',
                onChanged: (String p0) => checklist!.title = p0,
                validator: (String? value) => CustomValidator.isEmpty(value),
              ),
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: checklist?.items.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  final CheckItem item = checklist!.items[index];
                  return CheckListItemWidget(
                    item,
                    onTap: () => setState(() {
                      item.isChecked = !item.isChecked;
                    }),
                  );
                },
              ),
              const Text('New Item'),
              Row(
                children: <Widget>[
                  Expanded(
                      child: CustomTextFormField(
                    controller: _text,
                    hint: 'write task here...',
                    showSuffixIcon: false,
                  )),
                  TextButton(
                    onPressed: () {
                      if (_text.text.isEmpty) return;
                      checklist!.items.add(
                        CheckItem(
                          text: _text.text.trim(),
                          position: checklist!.items.length,
                        ),
                      );
                      _text.clear();
                      setState(() {});
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }
}
