import 'package:flutter/material.dart';

import '../../../utilities/custom_validators.dart';
import '../../../widgets/custom/custom_elevated_button.dart';

class JoinAgencyScreen extends StatefulWidget {
  const JoinAgencyScreen({Key? key}) : super(key: key);
  static const String routeName = '/join-agency';

  @override
  State<JoinAgencyScreen> createState() => _JoinAgencyScreenState();
}

class _JoinAgencyScreenState extends State<JoinAgencyScreen> {
  final TextEditingController _agencyCode = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Agency')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'To be the part of any agency please enter the agency code below',
                  textAlign: TextAlign.center,
                  style: TextStyle(),
                ),
              ),
              TextFormField(
                controller: _agencyCode,
                autocorrect: true,
                style: const TextStyle(fontSize: 48),
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) async => await onJoinAgency(),
                validator: (String? value) => CustomValidator.agency(value),
                decoration: InputDecoration(
                  hintText: 'Agency Code',
                  hintStyle: TextStyle(color: Theme.of(context).disabledColor),
                  border: InputBorder.none,
                ),
              ),
              CustomElevatedButton(
                title: 'Join Agency',
                isLoading: _isLoading,
                onTap: onJoinAgency,
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoinAgency() async {
    if (!_key.currentState!.validate()) return;
    try {
      setState(() {
        _isLoading = true;
      });
    } catch (e) {}
    setState(() {
      _isLoading = false;
    });
  }
}
