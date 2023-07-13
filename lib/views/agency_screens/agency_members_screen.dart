import 'package:flutter/material.dart';

import '../../database/local/local_agency.dart';
import '../../database/local/local_project.dart';
import '../../database/local/local_user.dart';
import '../../models/agency/agency.dart';
import '../../models/agency/member_detail.dart';
import '../../models/project/project.dart';
import '../../models/user/app_user.dart';
import '../../widgets/custom/custom_profile_photo.dart';
import '../../widgets/custom/custom_square_photo.dart';
import '../../widgets/custom/show_loading.dart';
import '../chat_screens/chat_dashboard_screen.dart';

class AgencyMembersScreen extends StatelessWidget {
  const AgencyMembersScreen({Key? key}) : super(key: key);
  static const String routeName = '/agency-members';
  @override
  Widget build(BuildContext context) {
    final List<MemberDetail> members =
        ModalRoute.of(context)!.settings.arguments as List<MemberDetail>;
    // TODO: On Edit
    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              FutureBuilder<Agency?>(
                  future: LocalAgency().currentlySelected(),
                  builder: (BuildContext context,
                      AsyncSnapshot<Agency?> agencySnapchot) {
                    if (agencySnapchot.hasData) {
                      final Agency agency = agencySnapchot.data!;
                      return GridView.builder(
                        primary: false,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 4 / 5,
                        ),
                        itemCount: members.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _MemberTile(
                              member: members[index], agency: agency);
                        },
                      );
                    } else {
                      return const ShowLoading();
                    }
                  }),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member, required this.agency});

  final MemberDetail member;
  final Agency agency;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser>(
      future: LocalUser().user(member.uid),
      builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
        if (snapshot.hasData) {
          final AppUser user = snapshot.data!;
          return ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Color(user.defaultColor)),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Color(user.defaultColor),
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: CustomProfilePhoto(user, size: 30),
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 4),
                  const SizedBox(height: 8),
                  Text(
                    user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    member.designation.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: FutureBuilder<List<Project>>(
                      future: LocalProject()
                          .projectByAgencyAndUID(agency.agencyID, user.uid),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Project>> proSnapshot) {
                        final List<Project> projects =
                            proSnapshot.data ?? <Project>[];
                        return SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: projects.isEmpty
                              ? const Text('Not in any project')
                              : ListView.separated(
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: projects.length,
                                  separatorBuilder: (__, _) =>
                                      const SizedBox(width: 8),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () =>
                                          Navigator.of(context).pushNamed(
                                        ProjectDashboardScreen.routeName,
                                        arguments: projects[index].pid,
                                      ),
                                      child: CustomSquarePhoto(
                                        projects[index].logo,
                                        name: projects[index].title,
                                        defaultColor:
                                            projects[index].defaultColor,
                                      ),
                                    );
                                  },
                                ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return const ShowLoading();
        }
      },
    );
  }
}
