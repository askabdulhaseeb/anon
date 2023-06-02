import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../functions/unique_id_fun.dart';
import '../../models/agency/agency.dart';
import '../../models/user/app_user.dart';
import 'auth_methods.dart';
import 'user_api.dart';

class AgencyAPI {
  static const String _collection = 'agencies';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<String?> create({
    required String name,
    required String webURL,
    required String logoURL,
  }) async {
    try {
      String code = UniqueIdFun.generateRandomString();
      final QuerySnapshot<Map<String, dynamic>> docs =
          await _instance.collection(_collection).get();
      for (int i = 0; i < docs.docs.length; i++) {
        final DocumentSnapshot<Map<String, dynamic>> ele = docs.docs[i];
        if ((ele.data()?['agency_id'].toString().toLowerCase() ?? '') ==
                code.toString().toLowerCase() ||
            (ele.data()?['agency_code'].toString().toLowerCase() ?? '') ==
                code.toString().toLowerCase() ||
            (ele.data()?['username'].toString().toLowerCase() ?? '') ==
                code.toString().toLowerCase()) {
          code = UniqueIdFun.generateRandomString();
          i = 0;
        }
      }
      final Agency value = Agency(
        agencyID: code,
        agencyCode: code,
        name: name.trim(),
        websiteURL: webURL.trim(),
      );
      await _instance
          .collection(_collection)
          .doc(value.agencyID)
          .set(value.toMap());
      final String meUID = AuthMethods.uid;
      final AppUser? userValue = await UserAPI().user(meUID);
      assert(userValue != null);
      userValue!.agencyIDs.add(value.agencyID);
      await UserAPI().updateAgency(userValue);
      return code;
    } on FirebaseException catch (e) {
      debugPrint("Failed with error '${e.code}': ${e.message}");
    }
    return null;
  }

  Future<void> agency(String value) async {
    try {
      await _instance.collection(_collection).doc(value).get();
    } on FirebaseException catch (e) {
      debugPrint("Failed with error '${e.code}': ${e.message}");
      throw 'e.code';
    }
  }
}
