import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../../models/project/project.dart';
import '../local/local_project.dart';
import 'auth_methods.dart';

class ProjectAPI {
  static const String _collection = 'projects';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<bool> create(Project value) async {
    try {
      await _instance.collection(_collection).doc(value.pid).set(value.toMap());
      await LocalProject().add(value);
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
          // .where('members', arrayContains: myUID)
          .get();
      final List<Project> tempResult = <Project>[];
      for (DocumentSnapshot<Map<String, dynamic>> element in docs.docs) {
        final Project temp = Project.fromMap(element);
        if (temp.members.contains(myUID)) {
          tempResult.add(temp);
        }
      }
      LocalProject().addAll(tempResult);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
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
