import 'package:flutter/material.dart';

import '../../database/firebase/auth_methods.dart';
import '../agency_screens/agency_joining_request_screen.dart';

class AgencyPage extends StatelessWidget {
  const AgencyPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(),
          const Center(child: Text('Agency')),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushNamed(AgencyJoiningRequestScreen.routeName),
            leading: const Icon(Icons.join_left_rounded),
            title: const Text('Pending Reuests'),
            subtitle: const Text('Tab here to check pending requests'),
          ),
          TextButton(
            onPressed: () async => await AuthMethods().signout(context),
            child: const Text('Signout'),
          ),
        ],
      ),
    );
  }
}
