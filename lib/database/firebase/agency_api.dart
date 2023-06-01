import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/agency/agency.dart';

class AgencyAPI {
  static const String _collection = 'agencies';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<void> add(Agency value) async {
    try {
      await _instance
          .collection(_collection)
          .doc(value.agencyID)
          .update(value.toMap());
    } catch (e) {
      throw 'Something going wrong';
    }
  }

  Future<void> view(String value) async {
    try {
      await _instance.collection(_collection).doc(value).get();
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
      throw 'e.code';
    }
  }
}
