import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_nav_provider.dart';
import '../../widgets/agency/agency_app_bar_title.dart';
import '../auth/agency_auth/switch_agency_screen.dart';
import '../main_pages/agency_page.dart';
import '../main_pages/project_page.dart';
import 'main_bottom_nav_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routeName = '/main';
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = const <Widget>[
      ProjectPage(),
      Center(child: Text('TODO')),
      AgencyPage(),
    ];
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
      body: Consumer<AppNavProvider>(
        builder: (BuildContext context, AppNavProvider appPro, _) {
          return pages[appPro.currentTap];
        },
      ),
      bottomNavigationBar: const MainBottomNavigationBar(),
    );
  }
}
