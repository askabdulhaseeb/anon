import 'package:flutter/material.dart';

import '../../../database/firebase/auth_methods.dart';
import '../../../widgets/auth/my_agencies_list.dart';
import '../../../widgets/custom/custom_profile_photo.dart';
import 'join_agency_screen.dart';

class SwitchAgencyScreen extends StatelessWidget {
  const SwitchAgencyScreen({Key? key}) : super(key: key);
  static const String routeName = '/switch-agency';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: <Widget>[
            CustomProfilePhoto(
              AuthMethods.getCurrentUser?.photoURL,
              name: AuthMethods.getCurrentUser?.displayName ?? 'Null',
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Hi, ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text:
                          '${AuthMethods.getCurrentUser?.displayName ?? 'null'} ',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => onMoreOption(context),
            icon: Icon(Icons.adaptive.more, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: <Widget>[
            const MyAgenciesList(),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(JoinAgencyScreen.routeName),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        'Join New Agency',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  onMoreOption(BuildContext context) {
    showBottomSheet(
      context: context,
      builder: (BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            onTap: () => AuthMethods().signout(context),
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sign out', style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }
}
