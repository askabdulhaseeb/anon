import 'package:flutter/material.dart';

import '../../database/firebase/auth_methods.dart';
import '../../database/local/local_chat.dart';
import '../../database/local/local_project.dart';
import '../../database/local/local_user.dart';
import '../../enums/chat/chat_member_role.dart';
import '../../models/chat/chat.dart';
import '../../models/chat/chat_group_member.dart';
import '../../models/chat/target_string.dart';
import '../../models/project/project.dart';
import '../../models/user/app_user.dart';
import '../../widgets/agency/addable_member_widget.dart';
import '../../widgets/chat/chat_member_tile.dart';
import '../../widgets/custom/custom_square_photo.dart';
import '../../widgets/custom/show_loading.dart';
import '../../widgets/custom/text_field_like_widget.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({Key? key}) : super(key: key);
  static const String routeName = '/chat-detail';

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  bool isLoading = false;
  final List<AppUser> members = <AppUser>[];
  @override
  Widget build(BuildContext context) {
    final String chatID = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: _Title(chatID: chatID),
      ),
      body: FutureBuilder<Chat>(
        future: LocalChat().chat(chatID),
        builder: (BuildContext context, AsyncSnapshot<Chat> snapshot) {
          if (snapshot.hasData) {
            final String me = AuthMethods.uid;
            final Chat chat = snapshot.data!;
            final bool canEdit = chat.members.any((ChatMember element) =>
                element.uid == me && element.role == ChatMemberRole.admin);
            members.addAll(chat.members
                .map((ChatMember e) => LocalUser().userWithoutFuture(e.uid))
                .toList());
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CustomSquarePhoto(
                    chat.imageURL,
                    name: chat.title,
                    defaultColor: chat.defaultColor,
                    size: 80,
                  ),
                  if (canEdit)
                    TextButton(
                      onPressed: () {},
                      child: const Text('Change Image'),
                    ),
                  if (chat.description.isNotEmpty)
                    TextFieldLikeWidget(child: Text(chat.description)),
                  if (canEdit && chat.targetString.isNotEmpty)
                    TextFieldLikeWidget(
                      child: Wrap(
                        children: chat.targetString
                            .map((TargetString e) => Text(e.target))
                            .toList(),
                      ),
                    ),
                  canEdit
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => addMember(chat),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Member'),
                          ),
                        )
                      : const SizedBox(height: 16),
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: chat.members.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChatMemberTile(
                        chat.members[index],
                        canEdit: canEdit,
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('ERROR'));
          } else {
            return const ShowLoading();
          }
        },
      ),
    );
  }

  Future<void> addMember(Chat chat) async {
    if (isLoading) return;
    final Project project = await LocalProject().project(chat.projectID);
    if (!mounted) return;
    final List<AppUser>? result = await showModalBottomSheet<List<AppUser>>(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (BuildContext context) => AddableMemberWidget(
        users: project.members,
        unRemoveableUID: project.createdBy,
        alreadyMember: chat.members
            .map((ChatMember e) => LocalUser().userWithoutFuture(e.uid))
            .toList(),
      ),
    );
    if (result == null) return;

    for (AppUser element in result) {
      final bool oldMember = chat.persons.contains(element.uid);
      if (!oldMember) {
        debugPrint(element.uid);
        chat.persons.add(element.uid);
        chat.members.add(ChatMember(uid: element.uid));
      }
    }
    await LocalChat().updateMembers(chat);
    setState(() {});
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.chatID});
  final String chatID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Chat>(
      future: LocalChat().chat(chatID),
      builder: (BuildContext context, AsyncSnapshot<Chat> snapshot) {
        if (snapshot.hasData) {
          final Chat chat = snapshot.data!;
          return Text(
            chat.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('ERROR'));
        } else {
          return const ShowLoading();
        }
      },
    );
  }
}
