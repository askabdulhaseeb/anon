import 'package:flutter/material.dart';

import '../../../functions/time_functions.dart';
import '../../../models/project/milestone.dart';
import '../../custom/custom_textformfield.dart';

class MilestoneInputTile extends StatefulWidget {
  const MilestoneInputTile(
    this.milestone, {
    required this.onChange,
    required this.onRemove,
    super.key,
  });
  final Milestone milestone;
  final Function(String title, DateTime? deadline, String amount) onChange;
  final VoidCallback onRemove;

  @override
  State<MilestoneInputTile> createState() => _MilestoneInputTileState();
}

class _MilestoneInputTileState extends State<MilestoneInputTile> {
  late TextEditingController _title;
  late TextEditingController _amount;
  DateTime? deadline;

  final FocusNode titleNode = FocusNode();
  final FocusNode amountNode = FocusNode();

  @override
  void initState() {
    _title = TextEditingController(text: widget.milestone.title);
    _amount = TextEditingController(
      text: widget.milestone.payment > 0 ? '${widget.milestone.payment}' : '',
    );
    deadline = widget.milestone.deadline;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomTextFormField(
          controller: _title,
          autoFocus: true,
          focusNode: titleNode,
          showSuffixIcon: false,
          hint: 'Title',
          onChanged: (String p0) => widget.onChange(p0, deadline, _amount.text),
          onFieldSubmitted: (_) =>
              FocusScope.of(context).requestFocus(amountNode),
        ),
        Row(
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                final DateTime? deadline = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 100),
                );
                if (deadline == null) return;
                widget.onChange(_title.text, deadline, _amount.text);
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: widget.milestone.deadline == null
                    ? Row(
                        children: <Widget>[
                          const Text('Deadline'),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.calendar_month_outlined,
                            color: Theme.of(context).primaryColor,
                          )
                        ],
                      )
                    : Text(TimeFun.deadlineDate(widget.milestone.deadline)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomTextFormField(
                controller: _amount,
                focusNode: amountNode,
                textAlign: TextAlign.end,
                onChanged: (String p0) =>
                    widget.onChange(_title.text, deadline, p0),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                showSuffixIcon: false,
                hint: '\$0.0',
              ),
            ),
            TextButton(
              onPressed: _title.text.isEmpty ? null : widget.onRemove,
              child: const Text('Remove'),
            ),
          ],
        ),
      ],
    );
  }
}
