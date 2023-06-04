import 'package:flutter/material.dart';

class CreateProjectScreen extends StatelessWidget {
  const CreateProjectScreen({Key? key}) : super(key: key);
  static const String routeName = '/create-projct';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CreateProjectScreen'),
      ),
      body: Center(
        child: Text('CreateProjectScreen'),
      ),
    );
  }
}
