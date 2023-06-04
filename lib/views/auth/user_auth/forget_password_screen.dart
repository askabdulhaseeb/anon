import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);
  static const String routeName = '/forget-password';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forget Password')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 120,
                child: FittedBox(
                  child: Icon(
                    CupertinoIcons.mail,
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
                child: FittedBox(
                  child: Text(
                    'Mail Send Successfully',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                child: Text(
                  'You can open your mail, and by clicking on the link you can change the password',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).disabledColor),
                ),
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
