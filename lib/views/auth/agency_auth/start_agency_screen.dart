import 'dart:io';

import 'package:flutter/material.dart';
import '../../../database/firebase/agency_api.dart';
import '../../../functions/helping_funcation.dart';
import '../../../functions/picker_functions.dart';
import '../../../utilities/custom_validators.dart';
import '../../../widgets/custom/custom_elevated_button.dart';
import '../../../widgets/custom/custom_network_change_img_box.dart';
import '../../../widgets/custom/custom_textformfield.dart';
import '../../../widgets/custom/custom_toast.dart';
import 'agency_welcome_screen.dart';

class StartAgencyScreen extends StatefulWidget {
  const StartAgencyScreen({Key? key}) : super(key: key);
  static const String routeName = '/start-agency';
  @override
  State<StartAgencyScreen> createState() => _StartAgencyScreenState();
}

class _StartAgencyScreenState extends State<StartAgencyScreen> {
  final String username = 'devmarkaz';
  final TextEditingController _name = TextEditingController();
  final TextEditingController _webURL = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final FocusNode nameNode = FocusNode();
  File? logo;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start Agency')),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomNetworkChangeImageBox(
                  title: 'Agency logo',
                  isDisable: isLoading,
                  file: logo,
                  onTap: () async {
                    final File? temp = await PickerFunctions().image();
                    if (temp == null) return;
                    setState(() {
                      logo = temp;
                    });
                    if (!mounted) return;
                    FocusScope.of(context).requestFocus(nameNode);
                  },
                ),
                CustomTextFormField(
                  controller: _name,
                  hint: 'Agency Name',
                  keyboardType: TextInputType.name,
                  focusNode: nameNode,
                  readOnly: isLoading,
                  validator: (String? value) => CustomValidator.agency(value),
                ),
                CustomTextFormField(
                  controller: _webURL,
                  hint: 'website: Ex. www.domain.com',
                  readOnly: isLoading,
                  validator: (String? value) => null,
                  onFieldSubmitted: (_) => onStartAgency(),
                ),
                const SizedBox(height: 16),
                CustomElevatedButton(
                  title: 'Start Agency',
                  isLoading: isLoading,
                  onTap: onStartAgency,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onStartAgency() async {
    if (!_key.currentState!.validate()) return;
    HelpingFuncation().dismissKeyboard(context);
    setState(() {
      isLoading = true;
    });
    try {
      final String? code = await AgencyAPI().create(
        name: _name.text,
        webURL: _webURL.text,
        logoFile: logo,
      );
      assert(code != null);
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AgencyWelcomeScreen.routeName,
        (Route<dynamic> route) => false,
        arguments: code,
      );
    } catch (e) {
      CustomToast.errorToast(message: 'Sonething goes wrong');
    }
    setState(() {
      isLoading = false;
    });
  }
}
