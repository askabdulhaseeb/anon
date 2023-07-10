import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../enums/user/user_type.dart';
import '../../functions/encryption.dart';
import '../../models/user/app_user.dart';
import '../../models/user/device_token.dart';
import '../../models/user/number_detail.dart';
import '../../views/auth/user_auth/sign_in_screen.dart';
import '../local/hive_db.dart';
import '../local/local_user.dart';
import 'notification_api.dart';
import 'user_api.dart';

class AuthMethods {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? get getCurrentUser => _auth.currentUser;
  static String get uid => _auth.currentUser?.uid ?? '';

  Future<User?> signupWithEmailAndPassword({
    required String email,
    required String password,
    NumberDetails? number,
    String? name,
    File? file,
    UserType? userType,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? user = result.user;
      assert(user != null);
      if (file != null) {
        final String? url = await UserAPI().uploadProfilePhoto(file: file);
        await _auth.currentUser!.updatePhotoURL(url);
      }
      if (name != null) await _auth.currentUser!.updateDisplayName(name);
      if (number?.number.isNotEmpty ?? false) {
        // TODO: save phone number
      }
      final String? token = await NotificationAPI().deviceToken();
      final AppUser appUser = AppUser(
        uid: uid,
        agencyIDs: <String>[],
        name: name ?? 'null',
        phoneNumber: number!,
        email: email,
        password: MyEncryption().encrypt(password, uid),
        type: userType ?? UserType.user,
        imageURL: _auth.currentUser!.photoURL ?? '',
        deviceToken: token == null
            ? <MyDeviceToken>[]
            : <MyDeviceToken>[MyDeviceToken(token: token)],
      );
      await UserAPI().register(appUser);
      await LocalUser().signIn(appUser);
      return user;
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? user = result.user;
      assert(user != null);
      final AppUser? appUser = await UserAPI().user(user!.uid);
      if (appUser == null) throw ('User Not found - register yourself');
      final String? token = await NotificationAPI().deviceToken();
      if (token != null) {
        if (!appUser.deviceToken
            .any((MyDeviceToken element) => element.token == token)) {
          appUser.deviceToken.add(MyDeviceToken(token: token));
          await UserAPI().updateToken(appUser);
        }
      }
      await LocalUser().signIn(appUser);
      return user;
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<bool> forgetPassword(String email) async {
    try {
      _auth.sendPasswordResetEmail(email: email.trim());
      return true;
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<void> signout(BuildContext context) async {
    _auth.signOut();
    await HiveDB().signOut();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushNamedAndRemoveUntil(
        SignInScreen.routeName, (Route<dynamic> route) => false);
  }
}
