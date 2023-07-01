import 'package:flutter/material.dart';

import '../../database/firebase/auth_methods.dart';
import '../../database/local/local_user.dart';
import '../../models/chat/chat_group_member.dart';
import '../../models/user/app_user.dart';
import '../custom/custom_profile_photo.dart';
import '../custom/show_loading.dart';

class ChatMemberTile extends StatelessWidget {
  const ChatMemberTile(this.member, {this.canEdit = false, super.key});
  final ChatMember member;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    final String me = AuthMethods.uid;
    return FutureBuilder<AppUser>(
      future: LocalUser().user(member.uid),
      builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
        if (snapshot.hasData ||
            snapshot.connectionState == ConnectionState.done) {
          final AppUser user = snapshot.data!;
          return ListTile(
            leading: CustomProfilePhoto(user),
            title: Text(user.name),
            trailing: me == member.uid || canEdit
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
