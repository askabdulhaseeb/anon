import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../database/firebase/auth_methods.dart';
import '../../../enums/user/user_type.dart';
import '../../../functions/picker_functions.dart';
import '../../../models/user/number_detail.dart';
import '../../../utilities/custom_validators.dart';
import '../../../widgets/auth/user_type_selection_widget.dart';
import '../../../widgets/custom/custom_elevated_button.dart';
import '../../../widgets/custom/custom_network_change_img_box.dart';
import '../../../widgets/custom/custom_textformfield.dart';
import '../../../widgets/custom/password_textformfield.dart';
import '../../../widgets/custom/phone_number_field.dart';
import '../agency_auth/join_agency_screen.dart';

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
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final FocusNode phoneNode = FocusNode();
  final FocusNode nameNode = FocusNode();
  final FocusNode passNode = FocusNode();
  final FocusNode confirmPassNode = FocusNode();
  PhoneNumber _number =
      PhoneNumber(countryCode: '+44', countryISOCode: 'GB', number: '');
  File? file;
  bool _isLoading = false;
  UserType userType = UserType.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _key,
            child: Column(
              children: <Widget>[
                CustomNetworkChangeImageBox(
                  title: 'Profile Image',
                  file: file,
                  isDisable: _isLoading,
                  onTap: () async {
                    final File? temp = await PickerFunctions().image();
                    assert(temp != null);
                    setState(() {
                      file = temp;
                    });
                    if (!mounted) return;
                    FocusScope.of(context).requestFocus(nameNode);
                  },
                ),
                CustomTextFormField(
                  controller: _name,
                  hint: 'Your full name',
                  autoFocus: true,
                  focusNode: nameNode,
                  keyboardType: TextInputType.name,
                  readOnly: _isLoading,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(phoneNode),
                  validator: (String? value) =>
                      CustomValidator.lessThen3(value),
                ),
                PhoneNumberField(
                  initialCountryCode: 'GB',
                  focusNode: phoneNode,
                  onChange: (PhoneNumber value) {
                    setState(() {
                      _number = value;
                    });
                  },
                ),
                CustomTextFormField(
                  controller: _email,
                  hint: 'Your Email',
                  keyboardType: TextInputType.emailAddress,
                  readOnly: _isLoading,
                  validator: (String? value) => CustomValidator.email(value),
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(passNode),
                ),
                PasswordTextFormField(
                  controller: _password,
                  focusNode: passNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(confirmPassNode),
                ),
                PasswordTextFormField(
                  controller: _confirmPassword,
                  title: 'Confirm Password',
                  focusNode: confirmPassNode,
                  validator: (String? value) => _password.text == value!
                      ? null
                      : 'Confirm Password is not same',
                ),
                UserTypeSelectionWidget(
                  initType: userType,
                  onSwitch: (UserType? value) => setState(() {
                    userType = value ?? UserType.user;
                  }),
                ),
                const SizedBox(height: 16),
                CustomElevatedButton(
                  title: 'Register'.toUpperCase(),
                  isLoading: _isLoading,
                  onTap: onRegister,
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onRegister() async {
    if (!_key.currentState!.validate()) return;
    try {
      setState(() {
        _isLoading = true;
      });
      final User? user = await AuthMethods().signupWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
        name: _name.text.trim(),
        file: file,
        number: NumberDetails(
          countryCode: _number.countryCode,
          number: _number.number,
          completeNumber: _number.completeNumber,
          isoCode: _number.countryISOCode,
        ),
      );
      if (user == null) throw ('Issue in register');
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
          JoinAgencyScreen.routeName, (Route<dynamic> route) => false);
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }
}
