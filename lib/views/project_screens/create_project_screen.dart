import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/new_project_provider.dart';
import '../../utilities/custom_validators.dart';
import '../../widgets/custom/custom_elevated_button.dart';
import '../../widgets/custom/custom_network_change_img_box.dart';
import '../../widgets/custom/custom_textformfield.dart';
import '../../widgets/project/new_project_add_member_widget.dart';
import '../../widgets/project/new_project_payment_type_widget.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({Key? key}) : super(key: key);
  static const String routeName = '/create-projct';

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<NewProjectProvider>(context, listen: false).reset();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('New Project')),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _key,
              child: Consumer<NewProjectProvider>(builder:
                  (BuildContext context, NewProjectProvider newProjPro, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomNetworkChangeImageBox(
                      file: newProjPro.logo,
                      title: 'Upload logo',
                      isDisable: newProjPro.isLoading,
                      onTap: () => newProjPro.attachMedia(context),
                    ),
                    CustomTextFormField(
                      controller: newProjPro.title,
                      focusNode: newProjPro.titleNode,
                      hint: 'Title',
                      keyboardType: TextInputType.name,
                      readOnly: newProjPro.isLoading,
                      validator: (String? value) =>
                          CustomValidator.lessThen3(value),
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(newProjPro.descriptionNode),
                    ),
                    CustomTextFormField(
                      controller: newProjPro.description,
                      focusNode: newProjPro.descriptionNode,
                      hint: 'Description',
                      maxLines: 5,
                      maxLength: 160,
                      readOnly: newProjPro.isLoading,
                      validator: (String? value) => null,
                      onFieldSubmitted: (_) async =>
                          await newProjPro.addMember(context),
                    ),
                    const NewProjectAddMemberWidget(),
                    const NewProjectPaymentTypeWidget(),
                    // TODO: milestone, payment, attachments
                    const SizedBox(height: 300),
                  ],
                );
              }),
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SizedBox(
            height: 60,
            child: Consumer<NewProjectProvider>(builder:
                (BuildContext context, NewProjectProvider newProjPro, _) {
              return CustomElevatedButton(
                title: 'Start Project',
                isLoading: newProjPro.isLoading,
                onTap: () => newProjPro.onStartProject(context, _key),
              );
            }),
          ),
        ),
      ),
    );
  }
}
