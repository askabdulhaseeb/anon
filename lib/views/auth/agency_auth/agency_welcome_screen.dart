import 'package:flutter/material.dart';

import '../../../functions/helping_funcation.dart';
import '../../../widgets/custom/custom_elevated_button.dart';
import '../../main_screen/main_screen.dart';

class AgencyWelcomeScreen extends StatelessWidget {
  const AgencyWelcomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/welcome-agency';
  @override
  Widget build(BuildContext context) {
    final String code = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 60),
            const SizedBox(
              height: 80,
              width: double.infinity,
              child: FittedBox(
                child: Text(
                  'Congratulations',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            Text(
              'You just started your new agency',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).disabledColor,
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 80,
              width: double.infinity,
              child: FittedBox(
                child: Text(
                  'Agency Code',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Text(
                    code,
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                IconButton(
                  splashRadius: 16,
                  onPressed: () =>
                      HelpingFuncation().copyToClipboard(context, code),
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Copy the agency code and share it with agency member to join your agency',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ),
            const Spacer(),
            const SizedBox(height: 24),
            const Spacer(),
            CustomElevatedButton(
              title: 'Open Agency dashboard',
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  MainScreen.routeName, (Route<dynamic> route) => false),
              isLoading: false,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
