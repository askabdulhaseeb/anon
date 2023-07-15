import 'dart:io';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../functions/time_functions.dart';
import '../../models/user/app_user.dart';
import '../local/local_data.dart';
import '../local/local_user.dart';
import 'auth_methods.dart';

class UserAPI {
  static const String _collection = 'users';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<void> register(AppUser value) async {
    try {
      await _instance.collection(_collection).doc(value.uid).set(value.toMap());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<AppUser?> user(String value) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await _instance.collection(_collection).doc(value).get();
      if (!doc.exists) return null;
      return AppUser.fromMap(doc);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<void> refresh(List<String> uids) async {
    try {
      final DateTime fetchingTime = DateTime.now();
      final int? temp = LocalData.lastMessageFetch();
      final DateTime time = TimeFun.miliToObject(temp) ??
          DateTime.now().subtract(const Duration(days: 7));
      int i = 0;
      int j = 0;
      do {
        final List<String> data = uids.length >= i + 9
            ? uids.sublist(i, (i + 9))
            : uids.sublist(i, uids.length);
        final QuerySnapshot<Map<String, dynamic>> doc = await _instance
            .collection(_collection)
            .where('uid', whereIn: data)
            .where('last_update', isGreaterThanOrEqualTo: time)
            .get();
        final List<DocumentChange<Map<String, dynamic>>> changes =
            doc.docChanges;
        if (changes.isNotEmpty) {
          for (DocumentChange<Map<String, dynamic>> element in changes) {
            final AppUser appUser = AppUser.fromMap(element.doc);
            j++;
            await LocalUser().add(appUser);
          }
        }
        i += 9;
      } while ((i * 10) < uids.length);
      LocalData.setLastUserFetch(fetchingTime.millisecondsSinceEpoch);
      log('User API: $j User refreshed');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<AppUser?> updateToken(AppUser value) async {
    try {
      await _instance
          .collection(_collection)
          .doc(value.uid)
          .update(value.deviceTokenMap());
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<void> updateAgency(AppUser value) async {
    try {
      await _instance
          .collection(_collection)
          .doc(value.uid)
          .update(value.updateAgencyMap());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String?> uploadProfilePhoto({
    required File file,
    bool updateAll = false,
  }) async {
    try {
      final String me = AuthMethods.uid;
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('profile_photos/$me')
          .putFile(file);
      String url = await snapshot.ref.getDownloadURL();
      AuthMethods.getCurrentUser!.updatePhotoURL(url);
      if (updateAll) {
        final AppUser? appuser = await LocalUser().updateProfileURL(url);
        if (appuser == null) return url;
        await _instance
            .collection(_collection)
            .doc(me)
            .update(appuser.profileURLMap());
      }
      return url;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
