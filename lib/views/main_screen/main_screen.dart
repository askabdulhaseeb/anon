import 'package:flutter/material.dart';

import '../../database/local/local_agency.dart';
import '../../models/agency/agency.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routeName = '/main';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MainScreen'),
      ),
      body: Center(
        child: FutureBuilder<bool>(
          future: LocalAgency().displayMainScreen(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) =>
              Text(snapshot.data == true ? 'true' : 'false'),
        ),
      ),
    );
  }
}
