import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/firebase/auth_methods.dart';
import '../../database/local/local_agency.dart';
import '../../database/local/local_user.dart';
import '../../enums/user/user_designation.dart';
import '../../models/agency/agency.dart';
import '../../models/agency/member_detail.dart';
import '../../models/user/app_user.dart';
import '../../widgets/custom/custom_list_tile_widget.dart';
import '../../widgets/custom/custom_profile_photo.dart';
import '../../widgets/custom/show_loading.dart';
import '../agency_screens/agency_details_screen.dart';
import '../agency_screens/agency_pending_request_screen.dart';
import '../agency_screens/agency_members_screen.dart';
import '../auth/agency_auth/switch_agency_screen.dart';
import '../system_screens/account_screen.dart';
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FutureBuilder<AppUser>(
                    future: LocalUser().user(AuthMethods.uid),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<AppUser> snapshot,
                    ) {
                      if (snapshot.hasData) {
                        final AppUser user = snapshot.data!;
                        return CustomListTileWidget(
                          leading: Hero(
                            tag: user.uid,
                            child: CustomProfilePhoto(user, size: 38),
                          ),
                          title: user.name,
                          verticallyCenter: true,
                          titleTextStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          trailing: forwardIcon,
                          onEdit: () => Navigator.of(context).pushNamed(
                            UserProfileScreeen.routeName,
                            arguments: user.uid,
                          ),
                        );
                      } else {
                        return const ShowLoading();
                      }
                    },
                  ),
                ),
                Divider(color: Colors.grey.shade300),
                ListTile(
                  leading: const Icon(Icons.workspace_premium_outlined),
                  title: const Text('Agency Details'),
                  trailing: forwardIcon,
                  onTap: () => Navigator.of(context).pushNamed(
                    AgencyDetailsScreen.routeName,
                    arguments: agency.agencyID,
                  ),
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
                  onTap: () => Navigator.of(context).pushNamed(
                    AgencyMembersScreen.routeName,
                    arguments: agency.activeMembers,
                  ),
                ),
                if (canEdit)
                  ListTile(
                    leading: const Icon(CupertinoIcons.person_add),
                    title: const Text('Pending Requests'),
                    trailing: forwardIcon,
                    onTap: () => Navigator.of(context)
                        .pushNamed(AgencyPendingRequestScreen.routeName),
                  ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.workspaces_outline),
                  title: const Text('Projects'),
                  trailing: forwardIcon,
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.chat_bubble_2),
                  title: const Text('Chat'),
                  trailing: forwardIcon,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(CupertinoIcons.person_alt_circle),
                  title: const Text('Account'),
                  trailing: forwardIcon,
                  onTap: () =>
                      Navigator.of(context).pushNamed(AccountScreen.routeName),
                ),
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
                const SizedBox(height: 40),
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
