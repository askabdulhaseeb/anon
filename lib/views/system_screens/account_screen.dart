import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/firebase/auth_methods.dart';
import '../../providers/app_theme_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);
  static const String routeName = '/account';
  @override
  Widget build(BuildContext context) {
    Icon forwardIcon = Icon(
      Icons.arrow_forward_ios_rounded,
      size: 16,
      color: Theme.of(context).disabledColor,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Consumer<AppThemeProvider>(
              builder: (BuildContext context, AppThemeProvider themePro, _) {
                return ListTile(
                  leading: const Icon(CupertinoIcons.bolt_circle),
                  title: const Text('Mode'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextButton(
                        onPressed: () => themePro.switchMode(ThemeMode.light),
                        child: Text(
                          'Light',
                          style: TextStyle(
                            color: themePro.isDarkMode
                                ? Colors.grey
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => themePro.switchMode(ThemeMode.dark),
                        child: Text(
                          'Dark',
                          style: TextStyle(
                            color: themePro.isDarkMode
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () => themePro.toggleTheme(themePro.isDarkMode),
                );
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete My Account'),
              trailing: forwardIcon,
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Signout'),
              trailing: forwardIcon,
              onTap: () async => await AuthMethods().signout(context),
            ),
          ],
        ),
      ),
    );
  }
}
