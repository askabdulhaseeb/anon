import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../database/firebase/project_api.dart';
import '../../database/local/local_agency.dart';
import '../../database/local/local_project.dart';
import '../../models/agency/agency.dart';
import '../../models/project/project.dart';
import '../../widgets/custom/custom_profile_photo.dart';
import '../../widgets/custom/show_loading.dart';
import '../project_screens/create_project_screen.dart';
import '../chat_screens/chat_dashboard_screen.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  String search = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () =>
              Navigator.of(context).pushNamed(CreateProjectScreen.routeName),
          leading: const Icon(Icons.now_widgets_outlined),
          title: const Text('Now Project'),
          subtitle: const Text('Tab here to start a new project'),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: CupertinoSearchTextField(
            onChanged: (String? value) {
              setState(() {
                search = value ?? '';
              });
            },
          ),
        ),
        _ProjectList(search: search),
      ],
    );
  }
}

class _ProjectList extends StatelessWidget {
  const _ProjectList({required this.search});
  final String search;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: FutureBuilder<Agency?>(
          future: LocalAgency().currentlySelected(),
          builder: (BuildContext context, AsyncSnapshot<Agency?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final Agency? agency = snapshot.data;
              return FutureBuilder<bool>(
                  future: ProjectAPI().refresh(agency?.agencyID ?? ''),
                  builder: (BuildContext context, _) {
                    return ValueListenableBuilder<Box<Project>>(
                        valueListenable: LocalProject().listenable(),
                        builder: (BuildContext context, Box<Project> box, _) {
                          final List<Project> projects = box.values
                              .toList()
                              .cast<Project>()
                              .where((Project element) =>
                                  element.agencies
                                      .contains(agency?.agencyID ?? 'null') &&
                                  element.title
                                      .toLowerCase()
                                      .contains(search.toLowerCase()))
                              .toList();
                          return ListView.builder(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            primary: false,
                            shrinkWrap: true,
                            itemCount: projects.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Project project = projects[index];
                              return ListTile(
                                leading: CustomProfilePhoto(
                                  project.logo,
                                  name: project.title,
                                ),
                                title: Text(
                                  project.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle:
                                    Text('Members: ${project.members.length}'),
                                trailing: const Text('Next deadline'),
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      ProjectDashboardScreen.routeName,
                                      arguments: project.pid);
                                },
                              );
                            },
                          );
                        });
                  });
            } else if (snapshot.hasError) {
              return const Text('ERROR');
            } else {
              return const ShowLoading();
            }
          },
        ),
      ),
    );
  }
}
