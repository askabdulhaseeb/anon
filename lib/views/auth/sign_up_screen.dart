import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../functions/picker_functions.dart';
import '../../utilities/custom_validators.dart';
import '../../widgets/custom/custom_elevated_button.dart';
import '../../widgets/custom/custom_network_change_img_box.dart';
import '../../widgets/custom/custom_textformfield.dart';
import '../../widgets/custom/password_textformfield.dart';
import '../../widgets/custom/phone_number_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const String routeName = '/signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  PhoneNumber _number =
      PhoneNumber(countryCode: '+44', countryISOCode: 'GB', number: '');
  File? file;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CustomNetworkChangeImageBox(
                title: 'Profile Image',
                onTap: () async {
                  final File? temp = await PickerFunctions().image();
                  if (temp == null) return;
                  setState(() {
                    file = temp;
                  });
                },
              ),
              CustomTextFormField(
                controller: _name,
                hint: 'Your full name',
                autoFocus: true,
                keyboardType: TextInputType.name,
                readOnly: _isLoading,
                validator: (String? value) => CustomValidator.lessThen3(value),
              ),
              PhoneNumberField(
                initialCountryCode: 'GB',
                onChange: (PhoneNumber value) => setState(() {
                  _number = value;
                }),
              ),
              CustomTextFormField(
                controller: _email,
                hint: 'Your Email',
                keyboardType: TextInputType.emailAddress,
                readOnly: _isLoading,
                validator: (String? value) => CustomValidator.lessThen3(value),
              ),
              PasswordTextFormField(controller: _password),
              PasswordTextFormField(
                controller: _confirmPassword,
                title: 'Confirm Password',
                validator: (String? value) => _password.text == value!
                    ? null
                    : 'Confirm Password is not same',
              ),
              const SizedBox(height: 16),
              CustomElevatedButton(
                title: 'Register',
                onTap: () async => await onRegister(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onRegister() async {}
}
