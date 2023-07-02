import 'package:flutter/material.dart';

import '../../database/firebase/auth_methods.dart';
import '../../database/local/local_agency.dart';
import '../../database/local/local_project.dart';
import '../../database/local/local_user.dart';
import '../../models/agency/agency.dart';
import '../../models/project/project.dart';
import '../../models/user/app_user.dart';
import '../../widgets/agency/addable_member_widget.dart';
import '../../widgets/custom/custom_square_photo.dart';
import '../../widgets/custom/custom_toast.dart';
import '../../widgets/custom/text_field_like_widget.dart';
import '../../widgets/project/milestone/project_milestone_display_tile.dart';
import '../../widgets/project/project_member_tile.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({Key? key}) : super(key: key);
  static const String routeName = '/project-detail';

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final String projectID =
        ModalRoute.of(context)!.settings.arguments as String;
    final String me = AuthMethods.uid;
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Project>(
          future: LocalProject().project(projectID),
          builder: (BuildContext context, AsyncSnapshot<Project> snapshot) {
            if (snapshot.hasData) {
              final Project project = snapshot.data!;
              return Text(project.title);
            } else {
              return const Text('Loading...');
            }
          },
        ),
        // members view
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Project>(
            future: LocalProject().project(projectID),
            builder: (BuildContext context, AsyncSnapshot<Project> snapshot) {
              if (snapshot.hasData) {
                final Project project = snapshot.data!;
                final bool canEdit = project.createdBy == me;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: <Widget>[
                      CustomSquarePhoto(
                        project.logo,
                        defaultColor: project.defaultColor,
                        name: project.title,
                        size: 80,
                      ),
                      if (canEdit)
                        TextButton(
                          onPressed: () {},
                          child: const Text('Change Image'),
                        ),
                      if (project.description.isNotEmpty)
                        TextFieldLikeWidget(child: Text(project.description)),
                      // if (canEdit && project.targetString.isNotEmpty)
                      //   TextFieldLikeWidget(
                      //     child: Wrap(
                      //       children: chat.targetString
                      //           .map((TargetString e) => Text(e.target))
                      //           .toList(),
                      //     ),
                      //   ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFieldLikeWidget(
                          child: Column(
                            children: <Widget>[
                              if (canEdit)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    onPressed: () => addMember(project),
                                    icon: const Icon(Icons.add),
                                    label: const Text('Update Milestone'),
                                  ),
                                ),
                              ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: project.milestone.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ProjectMilestoneDisplayTile(
                                    milestone: project.milestone[index],
                                    canEdit: canEdit,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextFieldLikeWidget(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            canEdit
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () => addMember(project),
                                      icon: const Icon(Icons.add),
                                      label: const Text('Add Member'),
                                    ),
                                  )
                                : const SizedBox(height: 16),
                            ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: project.members.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ProjectMemberTile(
                                  project.members[index],
                                  canEdit: canEdit,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('Loading'));
              }
            }),
      ),
    );
  }

  Future<void> addMember(Project project) async {
    if (isLoading) return;
    final Agency? agency = await LocalAgency().currentlySelected();
    if (agency == null) {
      if (!mounted) return;
      CustomToast.errorSnackBar(context, text: 'Facing Error');
      return;
    }
    if (!mounted) return;
    final List<AppUser>? result = await showModalBottomSheet<List<AppUser>>(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (BuildContext context) => AddableMemberWidget(
        users: agency.members,
        unRemoveableUID: project.createdBy,
        alreadyMember: project.members
            .map((String e) => LocalUser().userWithoutFuture(e))
            .toList(),
      ),
    );
    if (result == null) return;
    project.members.clear();
    project.members.addAll(result.map((AppUser e) => e.uid).toList());
    await LocalProject().updateMembers(project);
    setState(() {});
  }
}
