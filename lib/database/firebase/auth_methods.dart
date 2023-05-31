import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user/app_user.dart';
import 'user_api.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {} catch (e) {
      throw 'Issue during login';
    }
  }

  Future<void> forgetPassword({required String newPassword}) async {}

  Future<void> signout() async {
    _auth.signOut();
  }
}
