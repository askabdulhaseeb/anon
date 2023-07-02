import 'package:flutter/material.dart';

import '../../../functions/time_functions.dart';
import '../../../models/project/milestone.dart';

class ProjectMilestoneDisplayTile extends StatelessWidget {
  const ProjectMilestoneDisplayTile({
    required this.milestone,
    required this.canEdit,
    super.key,
  });
  final Milestone milestone;
  final bool canEdit;

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
              Text(milestone.status.title),
            ],
          ),
        ),
      ),
    );
  }
}
