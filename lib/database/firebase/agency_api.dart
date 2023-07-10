import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../../enums/user/user_designation.dart';
import '../../functions/unique_id_fun.dart';
import '../../models/agency/agency.dart';
import '../../models/agency/member_detail.dart';
import '../../models/user/app_user.dart';
import '../local/local_agency.dart';
import 'auth_methods.dart';
import 'user_api.dart';

class AgencyAPI {
  static const String _collection = 'agencies';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<String?> create({
    required String name,
    required String webURL,
    required File? logoFile,
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

      String url = '';
      if (logoFile != null) {
        url = await uploadLogo(file: logoFile, code: code) ?? '';
      }
      final Agency newAgencyValue = Agency(
        agencyID: code,
        agencyCode: code,
        name: name.trim(),
        websiteURL: webURL.trim(),
        logoURL: url,
      );
      await _instance
          .collection(_collection)
          .doc(newAgencyValue.agencyID)
          .set(newAgencyValue.toMap());
      final String meUID = AuthMethods.uid;
      final AppUser? userValue = await UserAPI().user(meUID);
      assert(userValue != null);
      userValue!.agencyIDs.add(newAgencyValue.agencyID);
      await UserAPI().updateAgency(userValue);
      await LocalAgency().add(newAgencyValue);
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

  Stream<bool> refreshAgency() {
    // final int? temp = LocalData.lastAgencyFetch();
    // final DateTime updatedTime = temp == null
    //     ? DateTime.now().subtract(const Duration(days: 3000))
    //     : TimeFun.miliToObject(temp);
    return _instance
        .collection(_collection)
        .where('members', arrayContains: AuthMethods.uid)
        .snapshots()
        .asyncMap((QuerySnapshot<Map<String, dynamic>> event) {
      final List<Agency> newChanges = <Agency>[];
      final List<DocumentChange<Map<String, dynamic>>> changes =
          event.docChanges;
      for (DocumentChange<Map<String, dynamic>> newEle in changes) {
        final Agency mod = Agency.fromDoc(newEle.doc);
        if (newEle.type == DocumentChangeType.removed &&
            (!mod.members.contains(AuthMethods.uid))) {
          LocalAgency().remove(mod.agencyID);
        } else {
          newChanges.add(mod);
        }
      }
      LocalAgency().refreshAgencies(newChanges);
      return true;
    });
  }

  Future<Agency?> joinAgency(String value) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> doc = await _instance
          .collection(_collection)
          .where('agency_code', isEqualTo: value)
          .get();
      if (doc.docs.isEmpty) return null;
      final Agency result = Agency.fromDoc(doc.docs[0]);
      final String myUID = AuthMethods.uid;
      if (result.activeMembers
          .any((MemberDetail element) => element.uid == myUID)) {
        result.isCurrenlySelected = true;
        await LocalAgency().add(result);
        return result;
      } else {
        result.onJoinRequest(
            myUID: myUID, designation: UserDesignation.employee);
        await _instance
            .collection(_collection)
            .doc(result.agencyID)
            .update(result.updateRequest());
        await LocalAgency().add(result);
        return result;
      }
    } on FirebaseException catch (e) {
      debugPrint("Failed with error '${e.code}': ${e.message}");
      throw 'e.code';
    }
  }

  Future<void> updateRequest(Agency value) async {
    try {
      await _instance
          .collection(_collection)
          .doc(value.agencyID)
          .update(value.updateRequest());
      await LocalAgency().add(value);
    } on FirebaseException catch (e) {
      debugPrint("Failed with error '${e.code}': ${e.message}");
      throw 'e.code';
    }
  }

  Future<void> leaveAgency({
    required Agency value,
    required String userID,
  }) async {
    value.onLeaveAgency(myUID: userID);
    try {
      await _instance
          .collection(_collection)
          .doc(value.agencyID)
          .update(value.updateRequest());
      await LocalAgency().leaveAgency(value.agencyID);
    } on FirebaseException catch (e) {
      debugPrint("Failed with error '${e.code}': ${e.message}");
      throw 'e.code';
    }
  }

  Future<List<Agency>> myAgencies() async {
    List<Agency> result = <Agency>[];
    try {
      final QuerySnapshot<Map<String, dynamic>> docs = await _instance
          .collection(_collection)
          .where('members', arrayContains: AuthMethods.uid)
          .get();
      for (DocumentSnapshot<Map<String, dynamic>> element in docs.docs) {
        final Agency temp = Agency.fromDoc(element);
        result.add(temp);
      }
      if (result.isNotEmpty) {
        await LocalAgency().addAll(result);
      }
    } on FirebaseException catch (e) {
      debugPrint("Failed with error '${e.code}': ${e.message}");
      throw 'e.code';
    }
    return result;
  }

  Future<String?> uploadLogo({
    required File file,
    required String code,
  }) async {
    try {
      TaskSnapshot snapshot =
          await FirebaseStorage.instance.ref('agency_logo/$code').putFile(file);
      String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }
}
