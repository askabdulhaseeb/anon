import 'package:flutter/material.dart';

import '../../../models/project/milestone.dart';
import '../../custom/custom_textformfield.dart';


class MilestoneInputTile extends StatefulWidget {
  const MilestoneInputTile(this.milestone, {required this.onChange, super.key});
  final Milestone milestone;
  final Function(String title, DateTime? deadline, String amount) onChange;

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
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: CustomTextFormField(
            controller: _title,
            autoFocus: true,
            focusNode: titleNode,
            showSuffixIcon: false,
            hint: 'Title',
            onChanged: (String p0) =>
                widget.onChange(p0, deadline, _amount.text),
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(amountNode),
          ),
        ),
        Container(
          width: 100,
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: const Text('Deadline'),
        ),
        Expanded(
          child: CustomTextFormField(
            controller: _amount,
            focusNode: amountNode,
            textAlign: TextAlign.end,
            onChanged: (String p0) =>
                widget.onChange(_title.text, deadline, p0),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            showSuffixIcon: false,
            hint: '\$0.0',
          ),
        ),
      ],
    );
  }
}
