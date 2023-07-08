import 'package:flutter/material.dart';

import '../../database/local/local_message.dart';
import '../../models/project/project.dart';
import '../../views/chat_screens/chat_dashboard_screen.dart';
import '../custom/custom_square_photo.dart';
import '../user/multi_user_display_widget.dart';

class ProjectListTile extends StatelessWidget {
  const ProjectListTile({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: CustomSquarePhoto(
        project.logo,
        defaultColor: project.defaultColor,
        name: project.title,
      ),
      title: Text(
        project.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: FutureBuilder<List<String>>(
        future: LocalMessage().listOfProjectUnseenMessages(project.pid),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) =>
            MultiUserDisplayWidget(snapshot.data ?? <String>[]),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            'Deadline',
            style: TextStyle(
              color: Theme.of(context).disabledColor,
            ),
          ),
          Text(project.nextDeadline()),
        ],
      ),
      onTap: () {
        Navigator.of(context).pushNamed(ProjectDashboardScreen.routeName,
            arguments: project.pid);
      },
    );
  }
}
