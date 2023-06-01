import 'package:flutter/material.dart';

import '../../database/firebase/auth_methods.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routeName = '/main';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MainScreen'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => AuthMethods().signout(),
          child: Text(AuthMethods.getCurrentUser?.displayName ?? 'null'),
        ),
      ),
    );
  }
}