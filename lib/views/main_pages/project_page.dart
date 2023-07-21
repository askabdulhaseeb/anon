import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../database/firebase/auth_methods.dart';
import '../../database/firebase/project_api.dart';
import '../../database/local/local_agency.dart';
import '../../database/local/local_project.dart';
import '../../enums/user/user_designation.dart';
import '../../models/agency/agency.dart';
import '../../models/agency/member_detail.dart';
import '../../models/project/project.dart';
import '../../widgets/custom/custom_icon_elevated_button.dart';
import '../../widgets/custom/show_loading.dart';
import '../../widgets/project/project_list_tile.dart';
import '../project_screens/create_project_screen.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String search = '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FutureBuilder<Agency?>(
        future: LocalAgency().currentlySelected(),
        builder: (BuildContext context, AsyncSnapshot<Agency?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final Agency? agency = snapshot.data;
            final bool myAgency = agency!.activeMembers
                    .firstWhere((MemberDetail element) =>
                        element.designation == UserDesignation.admin)
                    .uid ==
                AuthMethods.uid;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16),
                Text(
                  'Work Space',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                if (myAgency)
                  CustomIconElevatedButton(
                    title: 'Start New Project',
                    icon: Icons.add,
                    isLoading: false,
                    onTap: () => Navigator.of(context)
                        .pushNamed(CreateProjectScreen.routeName),
                  ),
                const Divider(height: 16),
                StatefulBuilder(builder: (
                  BuildContext context,
                  void Function(void Function()) setState,
                ) {
                  return CupertinoSearchTextField(
                    onChanged: (String? value) {
                      setState(() {
                        search = value ?? '';
                      });
                    },
                  );
                }),
                _ProjectList(search: search, agencyID: agency.agencyID),
              ],
            );
          } else {
            return const ShowLoading();
          }
        },
      ),
    );
  }
}

class _ProjectList extends StatelessWidget {
  const _ProjectList({required this.search, required this.agencyID});
  final String search;
  final String agencyID;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: StreamBuilder<void>(
          stream: ProjectAPI().refresh(agencyID),
          builder: (BuildContext context, _) {
            return ValueListenableBuilder<Box<Project>>(
              valueListenable: LocalProject().listenable(),
              builder: (BuildContext context, Box<Project> box, _) {
                final List<Project> projects =
                    LocalProject().boxToProjects(box, agencyID, search);
                return ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  primary: false,
                  shrinkWrap: true,
                  itemCount: projects.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Project project = projects[index];
                    return ProjectListTile(project: project);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
