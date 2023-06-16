import 'package:flutter/material.dart';

import '../../database/firebase/auth_methods.dart';
import '../../database/local/local_agency.dart';
import '../../enums/user/user_designation.dart';
import '../../models/agency/agency.dart';
import '../../models/agency/member_detail.dart';
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
          FutureBuilder<Agency?>(
              future: LocalAgency().currentlySelected(),
              builder: (BuildContext context, AsyncSnapshot<Agency?> snapshot) {
                if (snapshot.hasData) {
                  final Agency agency = snapshot.data ??
                      Agency(agencyID: '', agencyCode: '', name: '');
                  final String me = AuthMethods.uid;
                  return agency.agencyID.isNotEmpty &&
                          agency.activeMembers
                                  .firstWhere(
                                    (MemberDetail element) => element.uid == me,
                                    orElse: () => MemberDetail(
                                        uid: '',
                                        designation: UserDesignation.employee),
                                  )
                                  .designation ==
                              UserDesignation.admin
                      ? ListTile(
                          onTap: () => Navigator.of(context)
                              .pushNamed(AgencyJoiningRequestScreen.routeName),
                          leading: const Icon(Icons.join_left_rounded),
                          title: const Text('Pending Reuests'),
                          subtitle:
                              const Text('Tab here to check pending requests'),
                        )
                      : const SizedBox();
                } else {
                  return const SizedBox();
                }
              }),
          TextButton(
            onPressed: () async => await AuthMethods().signout(context),
            child: const Text('Signout'),
          ),
        ],
      ),
    );
  }
}
