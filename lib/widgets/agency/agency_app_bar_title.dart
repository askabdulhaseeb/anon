import 'package:flutter/material.dart';

import '../../database/local/local_agency.dart';
import '../../functions/helping_funcation.dart';
import '../../models/agency/agency.dart';
import '../custom/custom_square_photo.dart';
import '../custom/show_loading.dart';

class AgencyNameAppBarTitle extends StatelessWidget {
  const AgencyNameAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Agency?>(
        future: LocalAgency().currentlySelected(),
        builder: (BuildContext context, AsyncSnapshot<Agency?> snapshot) {
          if (snapshot.hasData) {
            final Agency result = snapshot.data ??
                Agency(agencyID: 'null', agencyCode: 'null', name: 'null');
            return GestureDetector(
              onTap: () => HelpingFuncation()
                  .copyToClipboard(context, result.agencyCode),
              child: Row(
                children: <Widget>[
                  CustomSquarePhoto(result.logoURL, name: result.name),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        result.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            result.agencyCode,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.copy, size: 12, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Text('ERROR');
          } else {
            return const ShowLoading();
          }
        });
  }
}
