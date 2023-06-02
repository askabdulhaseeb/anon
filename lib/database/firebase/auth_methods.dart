import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../enums/user/user_type.dart';
import '../../functions/firebase_exceptions.dart';
import '../../models/user/app_user.dart';
import '../../models/user/number_detail.dart';
import '../../widgets/custom/custom_toast.dart';
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
      final AppUser appUser = AppUser(
        uid: uid,
        agencyIDs: <String>[],
        name: name ?? '',
        phoneNumber: number!,
        email: email,
        password: password,
        type: userType ?? UserType.user,
        imageURL: _auth.currentUser!.photoURL ?? '',
      );
      await UserAPI().register(appUser);
      return user;
    } on FirebaseAuthException catch (e) {
      CustomToast.errorToast(message: CustomExceptions.auth(e));
    }
    return null;
  }

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      CustomToast.errorToast(message: CustomExceptions.auth(e));
    }
    return null;
  }

  Future<bool> forgetPassword(String email) async {
    try {
      _auth.sendPasswordResetEmail(email: email.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      CustomToast.errorToast(message: CustomExceptions.auth(e));
    }
    return false;
  }

  Future<void> deleteAccount() async {
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      CustomToast.errorToast(message: CustomExceptions.auth(e));
    }
  }

  Future<void> signout() async {
    _auth.signOut();
  }
}
