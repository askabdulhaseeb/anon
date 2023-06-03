import 'package:flutter/material.dart';

import '../../database/local/local_agency.dart';
import '../../functions/helping_funcation.dart';
import '../../models/agency/agency.dart';
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    result.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        result.agencyCode,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.copy, size: 12),
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
