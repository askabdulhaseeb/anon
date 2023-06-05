import 'package:flutter/material.dart';

class ProjectDashboardScreen extends StatelessWidget {
  const ProjectDashboardScreen({Key? key}) : super(key: key);
  static const String routeName = '/project-dashboard';
  @override
  Widget build(BuildContext context) {
    final String projectID =
        ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: const Text('Project Dashboard')),
      body: Center(child: Text(projectID)),
    );
  }
}
