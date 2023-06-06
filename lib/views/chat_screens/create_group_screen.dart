import 'package:flutter/material.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);
  static const String routeName = '/create-group';
  @override
  Widget build(BuildContext context) {
     final String projectID =
        ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('CreateGroupScreen'),
      ),
      body: Center(
        child: Text('CreateGroupScreen'),
      ),
    );
  }
}
