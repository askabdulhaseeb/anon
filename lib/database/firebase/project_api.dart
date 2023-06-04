import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../models/project/project.dart';
import '../local/local_project.dart';

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
}
