import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/firebase/agency_api.dart';
import '../../database/firebase/chat_api.dart';
import '../../database/firebase/message_api.dart';
import '../../database/local/local_user.dart';
import '../../providers/app_nav_provider.dart';
import '../../widgets/agency/agency_app_bar_title.dart';
import '../main_pages/boards_page.dart';
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
      BoardsPage(),
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
        child: FutureBuilder<void>(
            future: LocalUser().refreshUsers(),
            builder: (BuildContext context, _) {
              return StreamBuilder<bool>(
                  stream: AgencyAPI().refreshAgency(),
                  builder: (_, __) {
                    return StreamBuilder<void>(
                        stream: ChatAPI().refreshChats(),
                        builder: (_, __) {
                          return StreamBuilder<void>(
                              stream: MessageAPI().refreshMessages(),
                              builder: (_, __) {
                                return Consumer<AppNavProvider>(
                                  builder: (BuildContext context,
                                      AppNavProvider appPro, _) {
                                    return pages[appPro.currentTap];
                                  },
                                );
                              });
                        });
                  });
            }),
      ),
      bottomNavigationBar: const MainBottomNavigationBar(),
    );
  }
}
