import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/firebase/agency_api.dart';
import '../../database/firebase/chat_api.dart';
import '../../database/firebase/message_api.dart';
import '../../providers/app_nav_provider.dart';
import '../../widgets/agency/agency_app_bar_title.dart';
import '../main_pages/settings_page.dart';
import '../main_pages/project_page.dart';
import 'main_bottom_nav_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routeName = '/main';
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = const <Widget>[
      ProjectPage(),
      Center(child: Text('Coming soon...')),
      SettingsPage(),
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const AgencyNameAppBarTitle(),
        // actions: <Widget>[
        //   Builder(builder: (BuildContext context) {
        //     return IconButton(
        //       onPressed: () => onMoreOption(context),
        //       icon: Icon(Icons.adaptive.more, color: Colors.white),
        //     );
        //   }),
        // ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: StreamBuilder<bool>(
            stream: AgencyAPI().refreshAgency(),
            builder: (_, __) {
              return StreamBuilder<void>(
                  stream: MessageAPI().refreshMessages(),
                  builder: (_, __) {
                    return StreamBuilder<void>(
                        stream: ChatAPI().refreshChats(),
                        builder: (_, __) {
                          return Consumer<AppNavProvider>(
                            builder: (BuildContext context,
                                AppNavProvider appPro, _) {
                              return pages[appPro.currentTap];
                            },
                          );
                        });
                  });
            }),
      ),
      bottomNavigationBar: const MainBottomNavigationBar(),
    );
  }

  // onMoreOption(BuildContext context) {
  //   Scaffold.of(context).showBottomSheet(
  //     (BuildContext context) => Builder(builder: (BuildContext context) {
  //       return Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           Align(
  //             alignment: Alignment.centerRight,
  //             child: TextButton(
  //               onPressed: () => Navigator.of(context).pop(),
  //               child: const Text(
  //                 'Close',
  //                 style: TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           ),
  //           ListTile(
  //             onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
  //                 SwitchAgencyScreen.routeName,
  //                 (Route<dynamic> route) => false),
  //             leading: const Icon(CupertinoIcons.arrow_right_arrow_left),
  //             title: const Text('Switch Agency'),
  //           ),
  //           ListTile(
  //             onTap: () => AuthMethods().signout(context),
  //             leading: const Icon(
  //               CupertinoIcons.square_arrow_left,
  //               color: Colors.red,
  //             ),
  //             title:
  //                 const Text('Sign out', style: TextStyle(color: Colors.red)),
  //           )
  //         ],
  //       );
  //     }),
  //   );
  // }
}
