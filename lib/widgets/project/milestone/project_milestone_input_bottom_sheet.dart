import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/project/milestone.dart';
import 'milestone_input_tile.dart';

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
                    onRemove: () => setState(() {
                      widget.milestones.removeWhere(
                        (Milestone element) =>
                            element.milestoneID ==
                            widget.milestones[index].milestoneID,
                      );
                    }),
                  ),
                ),
              ),
              const Divider(),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    widget.milestones.add(
                      Milestone(
                        milestoneID: (widget.milestones.length + 1).toString(),
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
              const SizedBox(height: 400),
            ],
          ),
        );
      },
    );
  }
}
