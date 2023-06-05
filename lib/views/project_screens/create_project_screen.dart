import 'dart:io';

import 'package:flutter/material.dart';

import '../../database/firebase/project_api.dart';
import '../../database/local/local_agency.dart';
import '../../functions/helping_funcation.dart';
import '../../functions/picker_functions.dart';
import '../../functions/unique_id_fun.dart';
import '../../models/agency/agency.dart';
import '../../models/project/project.dart';
import '../../models/user/app_user.dart';
import '../../utilities/custom_validators.dart';
import '../../widgets/agency/addable_member_widget.dart';
import '../../widgets/custom/custom_elevated_button.dart';
import '../../widgets/custom/custom_network_change_img_box.dart';
import '../../widgets/custom/custom_profile_photo.dart';
import '../../widgets/custom/custom_textformfield.dart';
import '../../widgets/custom/custom_toast.dart';
import 'project_dashboard_screen.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({Key? key}) : super(key: key);
  static const String routeName = '/create-projct';

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  FocusNode titleNode = FocusNode();
  FocusNode descriptionNode = FocusNode();
  File? logo;
  bool isLoading = false;
  final List<AppUser> members = <AppUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Project')),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _key,
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
                  hint: 'Title',
                  keyboardType: TextInputType.name,
                  readOnly: isLoading,
                  validator: (String? value) =>
                      CustomValidator.lessThen3(value),
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(descriptionNode),
                ),
                CustomTextFormField(
                  controller: _description,
                  focusNode: descriptionNode,
                  hint: 'Description',
                  maxLines: 5,
                  maxLength: 160,
                  readOnly: isLoading,
                  validator: (String? value) => null,
                  onFieldSubmitted: (_) async => await addMember(),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: members.isEmpty
                            ? Center(
                                child: Text(
                                  'Click on add member 👉',
                                  style: TextStyle(
                                      color: Theme.of(context).disabledColor),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                primary: false,
                                scrollDirection: Axis.horizontal,
                                itemCount: members.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 10),
                                itemBuilder:
                                    (BuildContext context, int index) => Stack(
                                  alignment: Alignment.topRight,
                                  clipBehavior: Clip.none,
                                  children: <Widget>[
                                    CustomProfilePhoto(
                                      members[index].imageURL,
                                      name: members[index].name,
                                      size: 50,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          members.remove(members[index]);
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: addMember,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Members'),
                    ),
                  ],
                ),
                // add member
                const SizedBox(height: 16),
                CustomElevatedButton(
                  title: 'Start Project',
                  isLoading: isLoading,
                  onTap: onStartProject,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onStartProject() async {
    if (!_key.currentState!.validate()) return;
    HelpingFuncation().dismissKeyboard(context);
    try {
      setState(() {
        isLoading = true;
      });
      final Agency? agency = await LocalAgency().currentlySelected();
      if (agency == null) {
        CustomToast.errorToast(message: 'Reopen the Agency, please');
        setState(() {
          isLoading = false;
        });
        return;
      }
      final String pid = UniqueIdFun.unique();
      String url = '';
      if (logo != null) {
        url = await ProjectAPI().projectLogo(file: logo!, projectID: pid) ?? '';
      }
      final List<String> tempMember = members.map((e) => e.uid).toList();
      Project project = Project(
        pid: UniqueIdFun.unique(),
        title: _title.text.trim(),
        agencies: <String>[agency.agencyID],
        description: _description.text.trim(),
        logo: url,
        members: tempMember,
      );
      final bool added = await ProjectAPI().create(project);
      if (added) {
        if (!mounted) return;
        Navigator.of(context).popAndPushNamed(
          ProjectDashboardScreen.routeName,
          arguments: pid,
        );
      }
    } catch (e) {
      CustomToast.errorToast(message: 'Something wents wrong');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addMember() async {
    final Agency? agency = await LocalAgency().currentlySelected();
    if (agency == null) {
      CustomToast.errorToast(message: 'Facing Error');
      return;
    }
    if (!mounted) return;
    final List<AppUser>? result = await showModalBottomSheet<List<AppUser>>(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (BuildContext context) =>
          AddableMemberWidget(users: agency.members, alreadyMember: members),
    );
    if (result == null) return;
    members.clear();
    members.addAll(result);
    setState(() {});
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
