import 'package:flutter/material.dart';

import '../../database/firebase/auth_methods.dart';

class AgencyPage extends StatelessWidget {
  const AgencyPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(),
          const Center(child: Text('Agency')),
          TextButton(
            onPressed: () async => await AuthMethods().signout(context),
            child: const Text('Signout'),
          ),
        ],
      ),
    );
  }
}
