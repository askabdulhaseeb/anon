import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../functions/time_functions.dart';
import '../../models/project/milestone.dart';
import '../../providers/new_project_provider.dart';
import 'project_milestone_input_bottom_sheet.dart';

class NewProjectPaymentTypeWidget extends StatelessWidget {
  const NewProjectPaymentTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewProjectProvider>(
        builder: (BuildContext context, NewProjectProvider newProjPro, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Payment Type',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text('This information only displayed to admins'),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: Icon(
              newProjPro.hasMilestone ? Icons.circle_outlined : Icons.circle,
              color: Theme.of(context).primaryColor,
            ),
            title: const Text(
              'By Project',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: GestureDetector(
              onTap: () async {
                final DateTime? deadline = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 100),
                );
                if (deadline == null) return;
                newProjPro.onByProjectDeadlineUpdate(deadline);
              },
              child: Wrap(
                children: <Widget>[
                  const Text(
                    'Choose Dateline',
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(width: 10),
                  if (newProjPro.milestones.isNotEmpty)
                    Text(
                      TimeFun.deadlineDate(newProjPro.milestones[0].deadline),
                    )
                ],
              ),
            ),
            trailing: SizedBox(
              width: 100,
              child: TextFormField(
                initialValue: newProjPro.milestones.isEmpty
                    ? ''
                    : newProjPro.milestones[0].payment.toString(),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 6),
                  hintText: '0.0',
                  prefix: Text('USD '),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            onTap: () => newProjPro.onHasMilestoneUpdate(false),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: Icon(
              newProjPro.hasMilestone ? Icons.circle : Icons.circle_outlined,
              color: Theme.of(context).primaryColor,
            ),
            title: const Text(
              'By Milestones (Multiple Deadlines)',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle:
                Text('No. of Milestones: ${newProjPro.milestones.length}'),
            onTap: () async {
              newProjPro.onHasMilestoneUpdate(true);
              final List<Milestone>? milestones =
                  await showModalBottomSheet<List<Milestone>>(
                context: context,
                isScrollControlled: true,
                enableDrag: false,
                builder: (BuildContext context) =>
                    ProjectMilestoneInputBottomSheet(
                  milestones: newProjPro.milestones,
                ),
              );
              if (milestones == null) return;
              print(milestones.length);
              newProjPro.onMilestoneUpdate(milestones);
            },
          ),
        ],
      );
    });
  }
}
