import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/local/local_project.dart';
import '../../models/project/project.dart';
import '../../widgets/custom/show_loading.dart';

class ProjectDashboardScreen extends StatelessWidget {
  const ProjectDashboardScreen({Key? key}) : super(key: key);
  static const String routeName = '/project-dashboard';
  @override
  Widget build(BuildContext context) {
    final String projectID =
        ModalRoute.of(context)!.settings.arguments as String;
    String search = '';
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Project>(
            future: LocalProject().project(projectID),
            builder: (BuildContext context, AsyncSnapshot<Project> snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data?.title ?? 'Null',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall!.color),
                );
              } else if (snapshot.hasError) {
                return const Text('–ERROR-');
              } else {
                return const ShowLoading();
              }
            }),
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            child: const Text('Create Chat'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder<Project>(
            future: LocalProject().project(projectID),
            builder: (BuildContext context, AsyncSnapshot<Project> snapshot) {
              if (snapshot.hasData) {
                final Project project = snapshot.data!;
                return Column(
                  children: <Widget>[
                    StatefulBuilder(
                      builder: (BuildContext context, Function setState) {
                        return CupertinoSearchTextField(
                          onChanged: (String value) {
                            setState(() => search = value);
                          },
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Project Notes
                        },
                        child: Text('Imp. Notes (${project.notes.length})'),
                      ),
                    ),
                    //
                  ],
                );
              } else if (snapshot.hasError) {
                return const Text('ERROR');
              } else {
                return const ShowLoading();
              }
            }),
      ),
    );
  }
}
