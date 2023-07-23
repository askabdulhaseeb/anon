import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../database/local/board/local_board.dart';
import '../database/local/board/local_task_card.dart';
import '../database/local/local_user.dart';
import '../functions/bottom_sheet_fun.dart';
import '../models/board/board.dart';
import '../models/board/check_item.dart';
import '../models/board/check_list.dart';
import '../models/board/task_card.dart';
import '../models/user/app_user.dart';
import '../widgets/agency/addable_member_widget.dart';
import '../widgets/board/card/checklist/start_new_checklist_widget.dart';

class CardDisplayProvider extends ChangeNotifier {
  onTitleUpdate(BuildContext context) async {
    if (_card == null) return;
    final String? result = await BottomSheetFun().editableSheet(
      context,
      displayTitle: 'Card Title',
      initText: _card!.title,
    );
    if (result == null) return;
    _card!.title = result;
    onNeedToUpdate();
  }

  Future<void> onAssignTo(BuildContext context) async {
    if (_card == null) return;
    if (_addables.isEmpty) {
      final Board? board = await LocalBoard().boardByBoardID(_card!.boardID);
      if (board == null) return;
      _addables.addAll(board.persons);
    }
    final List<AppUser> members = <AppUser>[];
    for (String element in _card!.assignTo) {
      members.add(await LocalUser().user(element));
    }
    //
    // ignore: use_build_context_synchronously
    final List<AppUser>? result = await showModalBottomSheet<List<AppUser>>(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (BuildContext context) => AddableMemberWidget(
        users: _addables,
        alreadyMember: members,
        title: 'Assign Task',
        unRemoveableUID: '',
      ),
    );
    if (result == null) return;
    _needUpdate = true;
    _card!.assignTo.clear();
    _card!.assignTo.addAll(result.map((AppUser e) => e.uid).toSet().toList());
    onNeedToUpdate();
  }

  Future<void> onCreateChecklist(BuildContext context) async {
    if (_card == null) return;
    final CheckList? checklist = await showDialog(
      context: context,
      builder: (BuildContext context) => StartNewChecklistWidget(
        cardID: _card!.cardID,
        position: _card!.checklists.length,
      ),
    );
    if (checklist == null) return;
    _card!.checklists.add(checklist);
    await LocalTaskCard().update(_card!);
    onNeedToUpdate();
  }

  onChecklistItemUpdate(CheckList v, CheckItem item, DocumentChangeType type) {
    if (type == DocumentChangeType.added) {
      _card!.checklists
          .firstWhere(
              (CheckList element) => element.checkListID == v.checkListID)
          .items
          .toSet()
          .add(item);
    } else if (type == DocumentChangeType.modified) {
      _card!.checklists
          .firstWhere(
              (CheckList element) => element.checkListID == v.checkListID)
          .items
          .firstWhere((CheckItem ele) => ele.id == item.id)
          .isChecked = item.isChecked;
    }
    onNeedToUpdate();
  }

  //
  //

  _init() async {
    if (_card == null) return;
    final Board? board = await LocalBoard().boardByBoardID(_card!.boardID);
    if (board == null) return;
    _setAddables(board.persons);
  }

  void _setAddables(List<String> value) {
    _addables.addAll(value);
    notifyListeners();
  }

  Future<void> reset() async {
    if (_needUpdate && _card != null) {
      await LocalTaskCard().update(_card!);
    }
    _card = null;
    _addables.clear();
    _needUpdate = false;
  }

  void onNeedToUpdate({bool value = true}) {
    _needUpdate = value;
    notifyListeners();
  }

  TaskCard? get card => _card;
  void setCard(TaskCard? value) {
    _card = value;
    _init();
    notifyListeners();
  }

  bool _needUpdate = false;
  final List<String> _addables = <String>[];
  TaskCard? _card;
}
