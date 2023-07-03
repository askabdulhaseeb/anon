import 'package:flutter/material.dart';

import '../../../enums/project/milestone_status.dart';
import '../../../functions/time_functions.dart';
import '../../../models/project/milestone.dart';

class ProjectMilestoneDisplayTile extends StatelessWidget {
  const ProjectMilestoneDisplayTile({
    required this.milestone,
    required this.canEdit,
    required this.onMilestoneUpdate,
    super.key,
  });
  final Milestone milestone;
  final bool canEdit;
  final void Function(MilestoneStatus) onMilestoneUpdate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        dense: true,
        title: Text(milestone.title),
        subtitle: Text(TimeFun.deadlineDate(milestone.deadline)),
        trailing: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              !canEdit
                  ? const SizedBox()
                  : RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '${milestone.payment} ',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          ),
                          TextSpan(
                            text: milestone.currency,
                            style: TextStyle(
                              color: Theme.of(context).disabledColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
              Text(
                milestone.status.title,
                style: TextStyle(color: milestone.status.color),
              ),
            ],
          ),
        ),
        onTap: () async {
          final List<MilestoneStatus> list =
              MilestoneStatusConvertor().availableOption(milestone.status);
          if (list.isEmpty) return;
          final MilestoneStatus? result =
              await showModalBottomSheet<MilestoneStatus?>(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, right: 16),
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(null),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) => ListTile(
                      onTap: () {
                        Navigator.of(context).pop(list[index]);
                      },
                      title: Text(list[index].title),
                    ),
                  ),
                ],
              );
            },
          );
          if (result == null) return;
          onMilestoneUpdate(result);
        },
      ),
    );
  }
}
