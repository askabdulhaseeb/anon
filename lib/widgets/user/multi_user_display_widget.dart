import 'package:flutter/material.dart';

import '../../database/local/local_user.dart';
import '../../models/user/app_user.dart';
import '../custom/custom_profile_photo.dart';
import '../custom/show_loading.dart';

class MultiUserDisplayWidget extends StatelessWidget {
  const MultiUserDisplayWidget(
    this.users, {
    this.maxWidth = double.infinity,
    this.size = 11,
    this.emptyListWidget,
    super.key,
  });
  final List<String> users;
  final double maxWidth;
  final Widget? emptyListWidget;
  final double size;

  @override
  Widget build(BuildContext context) {
    return users.isEmpty
        ? emptyListWidget ?? const SizedBox()
        : Container(
            height: size * 2,
            width: ((size * 2) - (users.length * 2)) * users.length,
            constraints: maxWidth != double.infinity
                ? BoxConstraints(
                    maxWidth: users.length < 4
                        ? users.length *
                            ((size * 2) +
                                (users.length < 3 ? 0 : -users.length))
                        : maxWidth,
                  )
                : BoxConstraints(maxWidth: maxWidth),
            child: Stack(
              children: <Widget>[
                for (int i = 0; i < users.length; i++)
                  Positioned(
                    left: i * (size + 6),
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
            radius: size,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: CustomProfilePhoto(snapshot.data!, size: size - 2),
          );
        } else {
          return CircleAvatar(radius: size, child: const ShowLoading());
        }
      },
    );
  }
}
