import 'package:flutter/material.dart';

import '../../../database/firebase/auth_methods.dart';
import '../../../widgets/auth/my_agencies_list.dart';

class SwitchAgencyScreen extends StatelessWidget {
  const SwitchAgencyScreen({Key? key}) : super(key: key);
  static const String routeName = '/switch-agency';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            onPressed: () => AuthMethods().signout(context),
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Hi, ',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                  TextSpan(
                    text:
                        '${AuthMethods.getCurrentUser?.displayName ?? 'null'} ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const MyAgenciesList(),
            // FutureBuilder<List<Agency>>(
            //   future: AgencyAPI().myAgencies(),
            //   builder: (
            //     BuildContext context,
            //     AsyncSnapshot<List<Agency>> snapshot,
            //   ) {
            //     if (snapshot.hasData) {
            //       return const MyAgenciesList();
            //     } else if (snapshot.hasError) {
            //       return const MyAgenciesList();
            //     } else {
            //       return const ShowLoading();
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
