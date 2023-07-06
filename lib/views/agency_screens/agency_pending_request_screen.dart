import 'package:flutter/material.dart';

import '../../database/local/local_agency.dart';
import '../../models/agency/agency.dart';
import '../../widgets/agency/user_pending_request_tile.dart';
import '../../widgets/custom/show_loading.dart';

class AgencyPendingRequestScreen extends StatelessWidget {
  const AgencyPendingRequestScreen({Key? key}) : super(key: key);
  static const String routeName = '/agency-pending-request';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Requests')),
      body: FutureBuilder<Agency?>(
        future: LocalAgency().currentlySelected(),
        builder: (BuildContext context, AsyncSnapshot<Agency?> snapshot) {
          if (snapshot.hasData) {
            final Agency agency = snapshot.data ??
                Agency(agencyID: 'null', agencyCode: 'null', name: 'null');
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: agency.pendingRequest.isEmpty
                  ? const Center(child: Text('No request availale yet'))
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 24,
                        childAspectRatio: 4 / 4,
                      ),
                      itemCount: agency.pendingRequest.length,
                      itemBuilder: (BuildContext context, int index) {
                        return UserPendingRequestTile(
                          detail: agency.pendingRequest[index],
                          agency: agency,
                        );
                      },
                    ),
              // ListView.builder(
              //     itemCount: agency.pendingRequest.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       final MemberDetail detail =
              //           agency.pendingRequest[index];
              //       return UserPendingRequestTile(
              //         detail: detail,
              //         agency: agency,
              //       );
              //     },
              //   ),
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
