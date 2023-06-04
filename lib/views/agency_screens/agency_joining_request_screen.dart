import 'package:flutter/material.dart';

import '../../database/local/local_agency.dart';
import '../../models/agency/agency.dart';
import '../../models/agency/member_detail.dart';
import '../../widgets/agency/user_pending_request_tile.dart';
import '../../widgets/custom/show_loading.dart';

class AgencyJoiningRequestScreen extends StatelessWidget {
  const AgencyJoiningRequestScreen({Key? key}) : super(key: key);
  static const String routeName = '/agency-joining-request';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Requests')),
      body: FutureBuilder<Agency?>(
        future: LocalAgency().currentlySelected(),
        builder: (BuildContext context, AsyncSnapshot<Agency?> snapshot) {
          if (snapshot.hasData) {
            final Agency ayency = snapshot.data ??
                Agency(agencyID: 'null', agencyCode: 'null', name: 'null');
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ayency.pendingRequest.isEmpty
                  ? const Center(child: Text('No request availale yet'))
                  : ListView.builder(
                      itemCount: ayency.pendingRequest.length,
                      itemBuilder: (BuildContext context, int index) {
                        final MemberDetail detail =
                            ayency.pendingRequest[index];
                        return UserPendingRequestTile(
                          detail: detail,
                          agency: ayency,
                        );
                      },
                    ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something gets wrong'));
          } else {
            return const ShowLoading();
          }
        },
      ),
    );
  }
}
