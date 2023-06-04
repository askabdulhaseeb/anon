import 'dart:io';

import 'package:flutter/material.dart';

import '../../functions/picker_functions.dart';
import '../../utilities/custom_validators.dart';
import '../../widgets/custom/custom_elevated_button.dart';
import '../../widgets/custom/custom_network_change_img_box.dart';
import '../../widgets/custom/custom_textformfield.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({Key? key}) : super(key: key);
  static const String routeName = '/create-projct';

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  FocusNode titleNode = FocusNode();
  FocusNode descriptionNode = FocusNode();
  File? logo;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Project')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            CustomNetworkChangeImageBox(
              file: logo,
              title: 'Upload logo',
              isDisable: isLoading,
              onTap: attachMedia,
            ),
            CustomTextFormField(
              controller: _title,
              focusNode: titleNode,
              hint: 'Project Title',
              keyboardType: TextInputType.name,
              readOnly: isLoading,
              validator: (String? value) => CustomValidator.lessThen3(value),
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(descriptionNode),
            ),
            CustomTextFormField(
              controller: _description,
              focusNode: descriptionNode,
              hint: 'Project Title',
              maxLines: 5,
              maxLength: 160,
              readOnly: isLoading,
              validator: (String? value) => CustomValidator.lessThen3(value),
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(descriptionNode),
            ),
            // add member
            const SizedBox(height: 16),
            CustomElevatedButton(
              title: 'Start Project',
              isLoading: isLoading,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Future<void> attachMedia() async {
    final File? temp = await PickerFunctions().image();
    if (temp == null) return;
    setState(() {
      logo = temp;
    });
    if (!mounted) return;
    FocusScope.of(context).requestFocus(titleNode);
  }
}
