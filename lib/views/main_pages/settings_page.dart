import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/firebase/auth_methods.dart';
import '../../database/local/local_agency.dart';
import '../../database/local/local_user.dart';
import '../../enums/user/user_designation.dart';
import '../../models/agency/agency.dart';
import '../../models/agency/member_detail.dart';
import '../../models/user/app_user.dart';
import '../../widgets/custom/custom_profile_photo.dart';
import '../../widgets/custom/show_loading.dart';
import '../agency_screens/agency_joining_request_screen.dart';
import '../auth/agency_auth/switch_agency_screen.dart';
import '../user_screen/user_profile_screen.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Icon forwardIcon = Icon(
      Icons.arrow_forward_ios_rounded,
      size: 16,
      color: Theme.of(context).disabledColor,
    );
    return FutureBuilder<Agency?>(
      future: LocalAgency().currentlySelected(),
      builder: (BuildContext context, AsyncSnapshot<Agency?> snapshot) {
        if (snapshot.hasData) {
          final Agency agency =
              snapshot.data ?? Agency(agencyID: '', agencyCode: '', name: '');
          final String me = AuthMethods.uid;
          final bool canEdit = agency.activeMembers.any(
              (MemberDetail element) =>
                  element.uid == me &&
                  element.designation == UserDesignation.admin);
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                FutureBuilder<AppUser>(
                  future: LocalUser().user(AuthMethods.uid),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<AppUser> snapshot,
                  ) {
                    if (snapshot.hasData) {
                      final AppUser user = snapshot.data!;
                      return ListTile(
                        leading: CustomProfilePhoto(user),
                        title: Text(user.name),
                        subtitle:
                            user.nickName.isEmpty ? null : Text(user.nickName),
                        trailing: forwardIcon,
                        onTap: () => Navigator.of(context).pushNamed(
                          UserProfileScreeen.routeName,
                          arguments: user.uid,
                        ),
                      );
                    } else {
                      return const ShowLoading();
                    }
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.workspace_premium_outlined),
                  title: const Text('Agency Details'),
                  trailing: forwardIcon,
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.arrow_right_arrow_left),
                  title: const Text('Switch Agency'),
                  trailing: forwardIcon,
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      SwitchAgencyScreen.routeName,
                      (Route<dynamic> route) => false),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(CupertinoIcons.person_3),
                  title: const Text('Members'),
                  trailing: forwardIcon,
                  onTap: () {},
                ),
                if (canEdit)
                  ListTile(
                    leading: const Icon(CupertinoIcons.person_add),
                    title: const Text('Pending Requests'),
                    trailing: forwardIcon,
                    onTap: () => Navigator.of(context)
                        .pushNamed(AgencyJoiningRequestScreen.routeName),
                  ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(CupertinoIcons.chat_bubble_2),
                  title: const Text('Chat'),
                  trailing: forwardIcon,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(CupertinoIcons.info_circle),
                  title: const Text('Help'),
                  trailing: forwardIcon,
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.heart),
                  title: const Text('Tell a friend'),
                  trailing: forwardIcon,
                  onTap: () {},
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
