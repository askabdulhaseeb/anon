import 'package:flutter/material.dart';

import '../project_screens/create_project_screen.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ListTile(
            onTap: () =>
                Navigator.of(context).pushNamed(CreateProjectScreen.routeName),
            leading: const Icon(Icons.now_widgets_outlined),
            title: const Text('Now Project'),
            subtitle: const Text('Tab here to start a new project'),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  primary: false,
                  shrinkWrap: true,
                  itemCount: 1000,
                  itemBuilder: (BuildContext context, int index) {
                    return const Text('data');
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
