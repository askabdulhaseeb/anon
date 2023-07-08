import 'package:flutter/material.dart';

import '../../database/local/local_user.dart';
import '../../models/user/app_user.dart';
import '../custom/custom_profile_photo.dart';
import '../custom/show_loading.dart';

class MultiUserDisplayWidget extends StatelessWidget {
  const MultiUserDisplayWidget(this.users, {super.key});
  final List<String> users;

  @override
  Widget build(BuildContext context) {
    const double size = 10;
    return users.isEmpty
        ? const Text('Viewed')
        : SizedBox(
            height: size * 2.2,
            child: Stack(
              children: <Widget>[
                for (int i = 0; i < users.length; i++)
                  Positioned(
                    left: i * (size + 4),
                    child: _UserCircle(users[i], size: size),
                  ),
              ],
            ),
          );
  }
}

class _UserCircle extends StatelessWidget {
  const _UserCircle(this.uid, {required this.size});
  final String uid;
  final double size;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser>(
      future: LocalUser().user(uid),
      builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
        if (snapshot.hasData) {
          return CircleAvatar(
            radius: size + 2,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: CustomProfilePhoto(snapshot.data!, size: size),
          );
        } else {
          return CircleAvatar(radius: size, child: const ShowLoading());
        }
      },
    );
  }
}
