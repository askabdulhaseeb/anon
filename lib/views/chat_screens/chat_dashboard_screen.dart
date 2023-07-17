import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../database/firebase/auth_methods.dart';
import '../../database/local/local_chat.dart';
import '../../database/local/local_project.dart';
import '../../models/chat/chat.dart';
import '../../models/project/project.dart';
import '../../widgets/board/list/chat_board_task_list_display_widget.dart';
import '../../widgets/chat/chat_dashboard_tile.dart';
import '../../widgets/custom/show_loading.dart';
import '../project_screens/project_detail_screen.dart';
import 'create_chat_screen.dart';

class ProjectDashboardScreen extends StatelessWidget {
  const ProjectDashboardScreen({Key? key}) : super(key: key);
  static const String routeName = '/project-dashboard';
  @override
  Widget build(BuildContext context) {
    final String projectID =
        ModalRoute.of(context)!.settings.arguments as String;
    String search = '';
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Project>(
            future: LocalProject().project(projectID),
            builder: (BuildContext context, AsyncSnapshot<Project> snapshot) {
              if (snapshot.hasData) {
                return GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                    ProjectDetailScreen.routeName,
                    arguments: projectID,
                  ),
                  child: Text(
                    snapshot.data?.title ?? 'Null',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall!.color),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Text('–ERROR-');
              } else {
                return const ShowLoading();
              }
            }),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                onMoreOption(context, projectID);
              },
              icon: Icon(Icons.adaptive.more),
            );
          })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder<Project>(
            future: LocalProject().project(projectID),
            builder: (BuildContext context, AsyncSnapshot<Project> snapshot) {
              if (snapshot.hasData) {
                final Project project = snapshot.data!;
                // final bool canEdit = project.createdBy == AuthMethods.uid;
                return Column(
                  children: <Widget>[
                    StatefulBuilder(
                      builder: (BuildContext context, Function setState) {
                        return CupertinoSearchTextField(
                          onChanged: (String value) =>
                              setState(() => search = value),
                        );
                      },
                    ),
                    ChatBoardTaskListDisplayWidget(project.pid),
                    ValueListenableBuilder<Box<Chat>>(
                        valueListenable: LocalChat().listenable(),
                        builder: (BuildContext context, Box<Chat> box, _) {
                          final List<Chat> chats = LocalChat()
                              .boxToChats(box: box, projID: projectID);
                          final List<Chat> filterChat = chats
                              .where((Chat element) =>
                                  element.title.contains(search.toLowerCase()))
                              .toList();
                          filterChat.sort((Chat a, Chat b) => a.title
                              .toLowerCase()
                              .compareTo(b.title.toLowerCase()));
                          return ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: filterChat.length,
                            itemBuilder: (BuildContext context, int index) =>
                                ChatDashboardTile(filterChat[index]),
                          );
                        }),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Text('ERROR');
              } else {
                return const ShowLoading();
              }
            }),
      ),
    );
  }

  onMoreOption(BuildContext context, String projectID) {
    showBottomSheet(
      context: context,
      builder: (BuildContext context) => FutureBuilder<Project>(
          future: LocalProject().project(projectID),
          builder: (BuildContext context, AsyncSnapshot<Project> snapshot) {
            if (snapshot.hasData) {
              final Project project = snapshot.data!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ),
                  if (project.createdBy == AuthMethods.uid)
                    ListTile(
                      leading: const Icon(Icons.add),
                      dense: false,
                      title: const Text('Create New Chat Section'),
                      onTap: () => Navigator.of(context).popAndPushNamed(
                        CreateChatScreen.routeName,
                        arguments: projectID,
                      ),
                    ),
                  ListTile(
                    leading: const Icon(Icons.group),
                    dense: false,
                    title: const Text('Project and Member Management'),
                    onTap: () => Navigator.of(context).popAndPushNamed(
                      ProjectDetailScreen.routeName,
                      arguments: projectID,
                    ),
                  ),
                  project.createdBy == AuthMethods.uid
                      ? ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          dense: false,
                          title: const Text(
                            'Remove Project',
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () {},
                        )
                      : const ShowLoading(),
                  const SizedBox(height: 16),
                ],
              );
            } else if (snapshot.hasError) {
              return const Text('–ERROR-');
            } else {
              return const ShowLoading();
            }
          }),
    );
  }
}
