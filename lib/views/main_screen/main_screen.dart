import 'package:flutter/material.dart';

import '../../database/local/local_agency.dart';
import '../../widgets/agency/agency_app_bar_title.dart';
import '../auth/agency_auth/switch_agency_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routeName = '/main';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AgencyNameAppBarTitle(),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(SwitchAgencyScreen.routeName),
            child: const Text('Switch Agency'),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<bool>(
          future: LocalAgency().displayMainScreen(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) =>
              Text(snapshot.data == true ? 'true' : 'false'),
        ),
      ),
    );
  }
}
