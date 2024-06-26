import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../database/firebase/agency_api.dart';
import '../../database/firebase/auth_methods.dart';
import '../../database/local/local_agency.dart';
import '../../models/agency/agency.dart';
import '../../models/agency/member_detail.dart';
import '../../views/main_screen/main_screen.dart';
import '../custom/custom_square_photo.dart';
import '../custom/show_loading.dart';

class MyAgenciesList extends StatelessWidget {
  const MyAgenciesList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Agency>>(
        future: AgencyAPI().myAgencies(),
        builder: (BuildContext context, AsyncSnapshot<void> refreshSnapshot) {
          return FutureBuilder<Box<Agency>>(
            future: LocalAgency().refresh(),
            builder:
                (BuildContext context, AsyncSnapshot<Box<Agency>> snapshot) {
              if (snapshot.hasData) {
                final Box<Agency> openedBox = snapshot.data!;
                return ValueListenableBuilder<Box<Agency>>(
                  valueListenable: openedBox.listenable(),
                  builder: (BuildContext context, Box<Agency> box, _) {
                    final List<Agency> agencies =
                        box.values.toList().cast<Agency>();
                    return agencies.isEmpty
                        ? const _NoAgencyAvailable()
                        : Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: agencies.length,
                              itemBuilder: (BuildContext context, int index) {
                                return index == 0
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const Text(
                                            'Choose Agency',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          _AgencyTile(agency: agencies[index]),
                                        ],
                                      )
                                    : _AgencyTile(agency: agencies[index]);
                              },
                            ),
                          );
                  },
                );
              } else {
                return const ShowLoading();
              }
            },
          );
        });
  }
}

class _AgencyTile extends StatelessWidget {
  const _AgencyTile({required this.agency});

  final Agency agency;

  @override
  Widget build(BuildContext context) {
    final String myUID = AuthMethods.uid;
    final bool isAtchiveMember = agency.activeMembers.any(
        (MemberDetail element) => element.isAccepted && element.uid == myUID);
    return GestureDetector(
      onTap: isAtchiveMember
          ? () async {
              await LocalAgency().switchAgency(agency.agencyID);
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MainScreen.routeName, (Route<dynamic> route) => false);
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomSquarePhoto(
                agency.logoURL,
                name: agency.agencyCode,
                defaultColor: Colors.grey.value,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    agency.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  isAtchiveMember
                      ? Text(
                          'Members: ${agency.members.length}',
                          style:
                              TextStyle(color: Theme.of(context).disabledColor),
                        )
                      : const Text(
                          'Request no approved yet!',
                          style: TextStyle(color: Colors.red),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoAgencyAvailable extends StatelessWidget {
  const _NoAgencyAvailable();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: 120),
          Text('Not agency found'),
        ],
      ),
    );
  }
}
