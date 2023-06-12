import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/firebase/auth_methods.dart';
import '../../database/firebase/chat_api.dart';
import '../../database/local/local_project.dart';
import '../../models/chat/chat.dart';
import '../../models/project/project.dart';
import '../../widgets/chat/chat_dashboard_tile.dart';
import '../../widgets/custom/show_loading.dart';
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
                return Text(
                  snapshot.data?.title ?? 'Null',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall!.color),
                );
              } else if (snapshot.hasError) {
                return const Text('–ERROR-');
              } else {
                return const ShowLoading();
              }
            }),
        actions: <Widget>[
          FutureBuilder<Project>(
              future: LocalProject().project(projectID),
              builder: (BuildContext context, AsyncSnapshot<Project> snapshot) {
                if (snapshot.hasData) {
                  return ((snapshot.data?.createdBy ?? '') == AuthMethods.uid)
                      ? TextButton(
                          onPressed: () => Navigator.of(context).pushNamed(
                            CreateChatScreen.routeName,
                            arguments: projectID,
                          ),
                          child: const Text('Create Chat'),
                        )
                      : const SizedBox();
                } else if (snapshot.hasError) {
                  return const Text('–ERROR-');
                } else {
                  return const ShowLoading();
                }
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder<Project>(
            future: LocalProject().project(projectID),
            builder: (BuildContext context, AsyncSnapshot<Project> snapshot) {
              if (snapshot.hasData) {
                final Project project = snapshot.data!;
                return Column(
                  children: <Widget>[
                    StatefulBuilder(
                      builder: (BuildContext context, Function setState) {
                        return CupertinoSearchTextField(
                          onChanged: (String value) {
                            setState(() => search = value);
                          },
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Project Notes
                        },
                        child: Text('Imp. Notes (${project.notes.length})'),
                      ),
                    ),
                    //
                    StreamBuilder<List<Chat>>(
                      stream: ChatAPI().chats(projectID),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Chat>> snapshot) {
                        if (snapshot.hasData) {
                          final List<Chat> chats = snapshot.data ?? <Chat>[];
                          final List<Chat> filterChat = chats
                              .where((Chat element) =>
                                  element.title.contains(search))
                              .toList();
                          return ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: filterChat.length,
                            itemBuilder: (BuildContext context, int index) =>
                                ChatDashboardTile(filterChat[index]),
                          );
                        } else if (snapshot.hasError) {
                          debugPrint('CHAT ERROR: ${snapshot.error}');
                          return const Text('ERROR');
                        } else {
                          return const ShowLoading();
                        }
                      },
                    )
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
}
