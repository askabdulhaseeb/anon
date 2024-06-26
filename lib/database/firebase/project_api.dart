import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../enums/chat/chat_member_role.dart';
import '../../functions/time_functions.dart';
import '../../models/chat/chat.dart';
import '../../models/chat/chat_group_member.dart';
import '../../models/project/project.dart';
import '../../models/user/app_user.dart';
import '../local/local_data.dart';
import '../local/local_project.dart';
import 'auth_methods.dart';
import 'board/board_api.dart';
import 'chat_api.dart';

class ProjectAPI {
  static const String _collection = 'projects';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<bool> create(BuildContext context, Project value) async {
    try {
      await _instance.collection(_collection).doc(value.pid).set(value.toMap());
      await LocalProject().add(value);
      final String me = AuthMethods.uid;
      await ChatAPI().startChat(
        newChat: Chat(
          imageURL: '',
          persons: <String>[me],
          projectID: value.pid,
          members: <ChatMember>[
            ChatMember(uid: me, role: ChatMemberRole.admin),
          ],
          title: 'General',
          // ignore: use_build_context_synchronously
          defaultColor: Theme.of(context).primaryColor.value,
        ),
        receiver: <AppUser>[],
        sender: null,
      );
      await BoardAPI().createProjectBoard(value);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Stream<void> refresh(String agencyID) {
    final DateTime fetchingTime = DateTime.now();
    final DateTime? time = TimeFun.miliToObject(LocalData.lastProjectFetch());
    return time == null
        ? _instance
            .collection(_collection)
            .where('agencies', arrayContains: agencyID)
            .snapshots()
            .asyncMap((QuerySnapshot<Map<String, dynamic>> event) {
            _changeEventToLocal(event, fetchingTime);
          })
        : _instance
            .collection(_collection)
            .where('agencies', arrayContains: agencyID)
            .where('last_update', isGreaterThanOrEqualTo: time)
            .snapshots()
            .asyncMap((QuerySnapshot<Map<String, dynamic>> event) {
            _changeEventToLocal(event, fetchingTime);
          });
  }

  void _changeEventToLocal(
    QuerySnapshot<Map<String, dynamic>> event,
    DateTime fetchingTime,
  ) {
    final List<DocumentChange<Map<String, dynamic>>> changes = event.docChanges;
    if (changes.isEmpty) return;
    log('Project API: ${changes.length} changes in Projects');
    LocalData.setProjectFetch(fetchingTime
        .subtract(const Duration(minutes: 10))
        .millisecondsSinceEpoch);
    for (DocumentChange<Map<String, dynamic>> element in changes) {
      final Project pro = Project.fromDoc(element.doc);
      if (element.type == DocumentChangeType.removed ||
          !pro.members.contains(AuthMethods.uid)) {
        LocalProject().remove(pro);
      } else {
        LocalProject().add(pro);
      }
    }
  }

  Future<void> updateMembers(Project value) async {
    try {
      await _instance
          .collection(_collection)
          .doc(value.pid)
          .update(value.toUpdateMembers());
    } catch (e) {
      print(e);
    }
  }

  Future<void> update(Project value) async {
    try {
      await _instance
          .collection(_collection)
          .doc(value.pid)
          .update(value.toUpdate());
    } catch (e) {
      print(e);
    }
  }

  Future<String?> projectLogo({
    required File file,
    required String projectID,
  }) async {
    try {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('project-logo/$projectID')
          .putFile(file);
      String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }
}
