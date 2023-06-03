import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../database/local/local_agency.dart';
import '../../models/agency/agency.dart';
import '../../views/auth/agency_auth/join_agency_screen.dart';
import '../../views/main_screen/main_screen.dart';
import '../custom/custom_elevated_button.dart';
import '../custom/custom_network_image.dart';
import '../custom/show_loading.dart';

class MyAgenciesList extends StatelessWidget {
  const MyAgenciesList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box<Agency>>(
      future: LocalAgency().refresh(),
      builder: (BuildContext context, AsyncSnapshot<Box<Agency>> snapshot) {
        if (snapshot.hasData) {
          final Box<Agency> openedBox = snapshot.data!;
          return ValueListenableBuilder<Box<Agency>>(
            valueListenable: openedBox.listenable(),
            builder: (BuildContext context, Box<Agency> box, _) {
              final List<Agency> agencies = box.values.toList().cast<Agency>();
              return Expanded(
                child: agencies.isEmpty
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
                                    children: <Widget>[
                                      Text(
                                        'Choose Agency',
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Theme.of(context).disabledColor,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      _AgencyTile(agency: agencies[index]),
                                    ],
                                  )
                                : _AgencyTile(agency: agencies[index]);
                          },
                        ),
                      ),
              );
            },
          );
        } else {
          return const ShowLoading();
        }
      },
    );
  }
}

class _AgencyTile extends StatelessWidget {
  const _AgencyTile({required this.agency});

  final Agency agency;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await LocalAgency().switchAgency(agency.agencyID);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamedAndRemoveUntil(
            MainScreen.routeName, (Route<dynamic> route) => false);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomNetworkImage(
                size: 56,
                imageURL: agency.logoURL,
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
                  Text(
                    'Members: ${agency.members.length}',
                    style: TextStyle(color: Theme.of(context).disabledColor),
                  )
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
    return Center(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 120),
          const Text('Not agency found'),
          CustomElevatedButton(
            isLoading: false,
            onTap: () =>
                Navigator.of(context).pushNamed(JoinAgencyScreen.routeName),
            title: 'Join or start agency',
          ),
        ],
      ),
    );
  }
}