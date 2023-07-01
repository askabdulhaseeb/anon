import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../enums/chat/chat_member_role.dart';
import '../../models/chat/chat.dart';
import '../../models/chat/chat_group_member.dart';
import '../../models/project/project.dart';
import '../../models/user/app_user.dart';
import '../local/local_project.dart';
import 'auth_methods.dart';
import 'chat_api.dart';

class ProjectAPI {
  static const String _collection = 'projects';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<bool> create(BuildContext context, Project value) async {
    try {
      await _instance.collection(_collection).doc(value.pid).set(value.toMap());
      await LocalProject().add(value);
      final String me = AuthMethods.uid;
      ChatAPI().startChat(
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
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> refresh(String agencyID) async {
    final String myUID = AuthMethods.uid;
    try {
      final QuerySnapshot<Map<String, dynamic>> docs = await _instance
          .collection(_collection)
          .where('agencies', arrayContains: agencyID)
          .get();
      final List<Project> tempResult = <Project>[];
      for (DocumentSnapshot<Map<String, dynamic>> element in docs.docs) {
        final Project temp = Project.fromMap(element);
        if (temp.members.contains(myUID)) {
          tempResult.add(temp);
        }
      }
      if (tempResult.isNotEmpty) {
        await LocalProject().addAll(tempResult);
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
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
