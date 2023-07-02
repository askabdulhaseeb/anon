import 'dart:io';

import 'package:flutter/material.dart';

import '../database/firebase/auth_methods.dart';
import '../database/firebase/project_api.dart';
import '../database/local/local_agency.dart';
import '../database/local/local_user.dart';
import '../functions/helping_funcation.dart';
import '../functions/picker_functions.dart';
import '../functions/unique_id_fun.dart';
import '../models/agency/agency.dart';
import '../models/project/milestone.dart';
import '../models/project/project.dart';
import '../models/user/app_user.dart';
import '../views/chat_screens/chat_dashboard_screen.dart';
import '../widgets/agency/addable_member_widget.dart';
import '../widgets/custom/custom_toast.dart';

class NewProjectProvider extends ChangeNotifier {
  onStartProject(BuildContext context, GlobalKey<FormState> key) async {
    if (!key.currentState!.validate()) return;
    HelpingFuncation().dismissKeyboard(context);
    try {
      onIsLoadingUpdate(true);
      final Agency? agency = await LocalAgency().currentlySelected();
      if (agency == null) {
        // ignore: use_build_context_synchronously
        CustomToast.errorSnackBar(context,text: 'Reopen the Agency, please');
        onIsLoadingUpdate(false);
        return;
      }
      final String pid = UniqueIdFun.unique();
      final AppUser me = await LocalUser().user(AuthMethods.uid);
      String url = '';
      if (logo != null) {
        url = await ProjectAPI().projectLogo(file: logo!, projectID: pid) ?? '';
      }
      if (!members.any((AppUser element) => element.uid == me.uid)) {
        members.add(me);
      }
      final List<String> tempMember =
          members.map((AppUser e) => e.uid).toSet().toList();
      Project project = Project(
        pid: UniqueIdFun.unique(),
        title: _title.text.trim(),
        agencies: <String>[agency.agencyID],
        description: _description.text.trim(),
        logo: url,
        members: tempMember,
        milestone: _milestones,
        endingTime: _milestones.last.deadline,
        startingTime: _milestones.first.deadline,
      );
      // ignore: use_build_context_synchronously
      final bool added = await ProjectAPI().create(context, project);
      if (added) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).popAndPushNamed(
          ProjectDashboardScreen.routeName,
          arguments: pid,
        );
        reset();
      }
    } catch (e) {
      CustomToast.errorSnackBar(context,text: 'Something wents wrong');
      onIsLoadingUpdate(false);
    }
  }

  Future<void> addMember(BuildContext context) async {
    if (isLoading) return;
    final Agency? agency = await LocalAgency().currentlySelected();
    if (agency == null) {
      // ignore: use_build_context_synchronously
      CustomToast.errorSnackBar(context,text: 'Facing Error');
      return;
    }
    // ignore: use_build_context_synchronously
    final List<AppUser>? result = await showModalBottomSheet<List<AppUser>>(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (BuildContext context) => AddableMemberWidget(
          users: agency.members, alreadyMember: members, unRemoveableUID: ''),
    );
    if (result == null) return;
    members.clear();
    members.addAll(result);
    // ignore: use_build_context_synchronously
    FocusScope.of(context).requestFocus(_byProjectAmountNode);
  }

  Future<void> attachMedia(BuildContext context) async {
    if (isLoading) return;
    final File? temp = await PickerFunctions().image();
    if (temp == null) return;
    onLogoUpdate(temp);
    // ignore: use_build_context_synchronously
    FocusScope.of(context).requestFocus(titleNode);
  }

  void onByProjectPaymentUpdate(String value) {
    if (_milestones.isEmpty) {
      _milestones.add(
        Milestone(
          milestoneID: UniqueIdFun.generateRandomString(),
          title: 'By Project',
          index: 0,
          payment: double.tryParse(value) ?? 0.0,
        ),
      );
    } else {
      _milestones[0].payment = double.tryParse(value) ?? 0.0;
    }
  }

  void onByProjectDeadlineUpdate(DateTime value) {
    if (_milestones.isEmpty) {
      _milestones.add(
        Milestone(
          milestoneID: UniqueIdFun.generateRandomString(),
          title: 'By Project',
          index: 0,
          payment: 0.0,
          deadline: value,
        ),
      );
    } else {
      _milestones[0].deadline = value;
    }
    notifyListeners();
  }

  void onMilestoneUpdate(List<Milestone> value) {
    for (Milestone ele in value) {
      if (!_milestones.any((Milestone element) => element == ele)) {
        _milestones.add(ele);
      }
    }
    print(_milestones.length);
    notifyListeners();
  }

  void onRemoveMember(AppUser value) {
    members.remove(value);
    notifyListeners();
  }

  void onHasMilestoneUpdate(bool value) {
    if (!value) {
      _milestones.clear();
    }
    _hasMilestone = value;
    if (_hasMilestone) {
      _milestones.clear();
    }
    notifyListeners();
  }

  void onIsLoadingUpdate(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void onLogoUpdate(File value) {
    _logo = value;
    notifyListeners();
  }

  void reset() {
    _logo = null;
    _title.clear();
    _description.clear();
    _isLoading = false;
    _hasMilestone = false;
    _members.clear();
    _milestones.clear();
  }

  //
  //
  File? get logo => _logo;
  TextEditingController get title => _title;
  TextEditingController get description => _description;
  FocusNode get titleNode => _titleNode;
  FocusNode get descriptionNode => _descriptionNode;
  FocusNode get byProjectAmountNode => _byProjectAmountNode;
  bool get isLoading => _isLoading;
  List<AppUser> get members => _members;
  List<Milestone> get milestones => _milestones;
  bool get hasMilestone => _hasMilestone;
  //
  //
  File? _logo;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final FocusNode _titleNode = FocusNode();
  final FocusNode _descriptionNode = FocusNode();
  final FocusNode _byProjectAmountNode = FocusNode();
  bool _isLoading = false;
  final List<AppUser> _members = <AppUser>[];
  final List<Milestone> _milestones = <Milestone>[];
  bool _hasMilestone = false;
}
