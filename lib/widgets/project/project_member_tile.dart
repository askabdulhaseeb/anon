import 'package:flutter/material.dart';

import '../../database/firebase/auth_methods.dart';
import '../../database/local/local_user.dart';
import '../../models/user/app_user.dart';
import '../custom/custom_profile_photo.dart';
import '../custom/show_loading.dart';

class ProjectMemberTile extends StatelessWidget {
  const ProjectMemberTile(this.uid, {this.canEdit = false, super.key});
  final String uid;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    final String me = AuthMethods.uid;
    return FutureBuilder<AppUser>(
      future: LocalUser().user(uid),
      builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
        if (snapshot.hasData ||
            snapshot.connectionState == ConnectionState.done) {
          final AppUser user = snapshot.data!;
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: CustomProfilePhoto(user),
            title: Text(user.name),
            trailing: me == uid || canEdit
                ? IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.adaptive.more),
                  )
                : null,
          );
        } else {
          return const ShowLoading();
        }
      },
    );
  }
}
