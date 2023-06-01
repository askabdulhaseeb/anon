import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../models/user/app_user.dart';
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

  Future<String?> uploadProfilePhoto({required File file}) async {
    try {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('profile_photos/${AuthMethods.uid}')
          .putFile(file);
      String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }
}
