import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';

import '../../models/user/app_user.dart';
import 'user_api.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<AppUser> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final User user = await _auth.signIn(email.trim(), password.trim());
      final AppUser? appUser = await UserAPI().user(user.id);
      return appUser ?? (throw 'User not found');
    } catch (e) {
      throw 'Issue during login';
    }
  }

  Future<void> forgetPassword({required String newPassword}) async {
    await _auth.changePassword(newPassword);
  }

  Future<void> signout() async {
    _auth.signOut();
  }
}
