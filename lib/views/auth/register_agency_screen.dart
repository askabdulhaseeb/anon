import 'package:flutter/material.dart';

class RegisterAgencyScreen extends StatelessWidget {
  const RegisterAgencyScreen({Key? key}) : super(key: key);
  static const String routeName = '/register-agency';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RegisterAgencyScreen'),
      ),
      body: Center(
        child: Text('RegisterAgencyScreen'),
      ),
    );
  }
}
