import 'dart:io';

import 'package:flutter/material.dart';

import '../../functions/picker_functions.dart';
import '../../utilities/custom_validators.dart';
import '../../widgets/custom/custom_elevated_button.dart';
import '../../widgets/custom/custom_network_change_img_box.dart';
import '../../widgets/custom/custom_textformfield.dart';

class RegisterAgencyScreen extends StatefulWidget {
  const RegisterAgencyScreen({Key? key}) : super(key: key);
  static const String routeName = '/register-agency';
  @override
  State<RegisterAgencyScreen> createState() => _RegisterAgencyScreenState();
}

class _RegisterAgencyScreenState extends State<RegisterAgencyScreen> {
  final TextEditingController _name = TextEditingController();
  final String username = 'devmarkaz';
  final TextEditingController _webURL = TextEditingController();
  File? logo;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Agency')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomNetworkChangeImageBox(
              title: 'Agency logo',
              onTap: () async {
                final File? temp = await PickerFunctions().image();
                if (temp == null) return;
                setState(() {
                  logo = temp;
                });
              },
            ),
            CustomTextFormField(
              controller: _name,
              hint: 'Agency Name',
              readOnly: isLoading,
              validator: (String? value) => CustomValidator.lessThen3(value),
            ),
            CustomTextFormField(
              controller: _webURL,
              hint: 'website: ex, www.exemple.com',
              readOnly: isLoading,
              validator: (String? value) => null,
            ),
            SizedBox(
              height: 40,
              child: FittedBox(child: Text(username)),
            ),
            Text(
              'You can edit the username later',
              style: TextStyle(color: Theme.of(context).disabledColor),
            ),
            const SizedBox(height: 16),
            CustomElevatedButton(
              title: 'Add Agency',
              onTap: () async => await onStartAgency(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onStartAgency() async {
    // loading
  }
}
