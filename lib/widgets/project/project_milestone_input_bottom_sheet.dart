import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/project/milestone.dart';
import '../custom/custom_textformfield.dart';

class ProjectMilestoneInputBottomSheet extends StatefulWidget {
  const ProjectMilestoneInputBottomSheet({required this.milestones, super.key});
  final List<Milestone> milestones;

  @override
  State<ProjectMilestoneInputBottomSheet> createState() =>
      _ProjectMilestoneInputBottomSheetState();
}

class _ProjectMilestoneInputBottomSheetState
    extends State<ProjectMilestoneInputBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                    Text(
                      'Milestones',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(widget.milestones),
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: widget.milestones.length,
                  itemBuilder: (BuildContext context, int index) =>
                      MilestoneInputTile(
                    widget.milestones[index],
                    onChange: (
                      String title,
                      DateTime? deadline,
                      String amount,
                    ) {
                      widget.milestones[index].title = title;
                      widget.milestones[index].deadline = deadline;
                      widget.milestones[index].payment =
                          double.tryParse(amount) ?? 0.0;
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      widget.milestones.add(
                        Milestone(
                          milestoneID:
                              (widget.milestones.length + 1).toString(),
                          title: '',
                          payment: 0,
                          index: widget.milestones.length,
                        ),
                      );
                    });
                  },
                  icon: const Icon(CupertinoIcons.add, size: 18),
                  label: const Text('Add Milestone'),
                ),
              ),
              const SizedBox(height: 400),
            ],
          ),
        );
      },
    );
  }
}

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
