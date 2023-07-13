import 'package:flutter/material.dart';

import '../../database/firebase/auth_methods.dart';
import '../../database/local/local_chat.dart';
import '../../database/local/local_user.dart';
import '../../enums/chat/chat_member_role.dart';
import '../../models/chat/chat.dart';
import '../../models/chat/chat_group_member.dart';
import '../../models/user/app_user.dart';
import '../custom/custom_profile_photo.dart';
import '../custom/show_loading.dart';

class ChatMemberTile extends StatelessWidget {
  const ChatMemberTile(this.member,
      {this.canEdit = false, this.chat, super.key});
  final ChatMember member;
  final bool canEdit;
  final Chat? chat;

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
                ? PopupMenuButton<String>(
                    onSelected: (String value) async {
                      if (canEdit == false || chat == null) return;
                      switch (value) {
                        case 'remove':
                          chat!.removeMember(user.uid);
                        case 'admin':
                          chat!.makeAdmin(user.uid);
                        case 'member':
                          chat!.makeMember(user.uid);
                          break;
                        default:
                          chat!.makeMember(user.uid);
                      }
                      await LocalChat().updateMember(chat!);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuItem<String>>[
                      if (canEdit &&
                          member.role == ChatMemberRole.admin &&
                          chat!.members
                                  .where((ChatMember element) =>
                                      element.role == ChatMemberRole.admin)
                                  .length >
                              1 &&
                          member.role != ChatMemberRole.admin)
                        const PopupMenuItem<String>(
                          value: 'remove',
                          child: Text('Remove'),
                        ),
                      if (canEdit && member.role == ChatMemberRole.member)
                        const PopupMenuItem<String>(
                          value: 'admin',
                          child: Text('Make admin'),
                        ),
                      if (canEdit &&
                          member.role == ChatMemberRole.admin &&
                          chat!.members
                                  .where((ChatMember element) =>
                                      element.role == ChatMemberRole.admin)
                                  .length >
                              1)
                        const PopupMenuItem<String>(
                          value: 'member',
                          child: Text('Make Member'),
                        ),
                    ],
                  )
                : null,
            subtitle: Text(chat?.members
                    .firstWhere((ChatMember element) => element.uid == user.uid)
                    .role
                    .title ??
                member.role.title),
          );
        } else {
          return const ShowLoading();
        }
      },
    );
  }
}
