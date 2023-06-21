import 'dart:io';

import 'package:flutter/material.dart';

import '../../database/firebase/auth_methods.dart';
import '../../database/firebase/chat_api.dart';
import '../../database/local/local_project.dart';
import '../../database/local/local_user.dart';
import '../../enums/chat/chat_member_role.dart';
import '../../enums/chat/message_type.dart';
import '../../functions/picker_functions.dart';
import '../../functions/unique_id_fun.dart';
import '../../models/chat/chat.dart';
import '../../models/chat/chat_group_member.dart';
import '../../models/chat/message.dart';
import '../../models/chat/message_read_info.dart';
import '../../models/project/attachment.dart';
import '../../models/project/project.dart';
import '../../models/user/app_user.dart';
import '../../utilities/custom_validators.dart';
import '../../widgets/agency/addable_member_widget.dart';
import '../../widgets/custom/custom_elevated_button.dart';
import '../../widgets/custom/custom_network_change_img_box.dart';
import '../../widgets/custom/custom_profile_photo.dart';
import '../../widgets/custom/custom_textformfield.dart';

class CreateChatScreen extends StatefulWidget {
  const CreateChatScreen({Key? key}) : super(key: key);
  static const String routeName = '/create-chat';

  @override
  State<CreateChatScreen> createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  FocusNode titleNode = FocusNode();
  FocusNode descriptionNode = FocusNode();
  File? logo;
  bool isLoading = false;
  final List<AppUser> members = <AppUser>[];
  @override
  Widget build(BuildContext context) {
    final String projectID =
        ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: const Text('Create Chat')),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _key,
            child: Column(
              children: <Widget>[
                CustomNetworkChangeImageBox(
                  file: logo,
                  title: 'Upload logo',
                  isDisable: isLoading,
                  onTap: attachMedia,
                ),
                CustomTextFormField(
                  controller: _title,
                  focusNode: titleNode,
                  hint: 'Title',
                  keyboardType: TextInputType.name,
                  readOnly: isLoading,
                  validator: (String? value) =>
                      CustomValidator.lessThen3(value),
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(descriptionNode),
                ),
                CustomTextFormField(
                  controller: _description,
                  focusNode: descriptionNode,
                  hint: 'Description',
                  maxLines: 5,
                  maxLength: 160,
                  readOnly: isLoading,
                  validator: (String? value) => null,
                  onFieldSubmitted: (_) async => await addMember(projectID),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: members.isEmpty
                            ? Center(
                                child: Text(
                                  'Click on add member 👉',
                                  style: TextStyle(
                                      color: Theme.of(context).disabledColor),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                primary: false,
                                scrollDirection: Axis.horizontal,
                                itemCount: members.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 10),
                                itemBuilder:
                                    (BuildContext context, int index) => Stack(
                                  alignment: Alignment.topRight,
                                  clipBehavior: Clip.none,
                                  children: <Widget>[
                                    CustomProfilePhoto(
                                      members[index].imageURL,
                                      name: members[index].name,
                                      size: 50,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          members.remove(members[index]);
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async => await addMember(projectID),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Members'),
                    ),
                  ],
                ),
                // add member
                const SizedBox(height: 16),
                CustomElevatedButton(
                  title: 'Start Chat',
                  isLoading: isLoading,
                  onTap: () async => await onStartChat(projectID),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onStartChat(String projectID) async {
    if (!_key.currentState!.validate()) return;
    try {
      setState(() {
        isLoading = true;
      });
      final String chatID = UniqueIdFun.chatID(projectID);
      String logoURL = '';
      if (logo != null) {
        final String? url = await ChatAPI().uploadChatLogo(
          file: logo!,
          chatID: chatID,
        );
        if (url != null) {
          logoURL = url;
        }
      }
      final AppUser sender = await LocalUser().user(AuthMethods.uid);
      members.add(sender);
      final List<String> receivers =
          members.map((AppUser e) => e.uid).toSet().toList();
      final Message message = Message(
        text: 'Create new chat',
        chatID: chatID,
        projectID: projectID,
        type: MessageType.announcement,
        displayString: 'Create new chat',
        attachment: <Attachment>[],
        sendTo:
            members.map((AppUser e) => MessageReadInfo(uid: e.uid)).toList(),
        sendToUIDs: receivers,
      );
      final Chat chat = Chat(
        imageURL: logoURL,
        persons: receivers,
        projectID: projectID,
        members: members
            .map((AppUser e) => ChatMember(
                uid: e.uid,
                role: AuthMethods.uid == e.uid
                    ? ChatMemberRole.admin
                    : ChatMemberRole.member))
            .toList(),
        chatID: chatID,
        description: _description.text,
        title: _title.text,
        lastMessage: message,
      );
      await ChatAPI()
          .startChat(newChat: chat, receiver: members, sender: sender);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> addMember(String projectID) async {
    // final Agency? agency = await LocalAgency().currentlySelected();
    if (isLoading) return;
    final Project project = await LocalProject().project(projectID);
    if (!mounted) return;
    final List<AppUser>? result = await showModalBottomSheet<List<AppUser>>(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (BuildContext context) => AddableMemberWidget(
        users: project.members,
        unRemoveableUID: project.createdBy,
        alreadyMember: members,
      ),
    );
    if (result == null) return;
    members.clear();
    members.addAll(result);
    setState(() {});
  }

  Future<void> attachMedia() async {
    final File? temp = await PickerFunctions().image();
    if (temp == null) return;
    setState(() {
      logo = temp;
    });
    if (!mounted) return;
    FocusScope.of(context).requestFocus(titleNode);
  }
}
