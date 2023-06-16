import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/firebase/auth_methods.dart';
import '../../../providers/app_theme_provider.dart';
import '../../../utilities/app_images.dart';
import '../../../utilities/custom_validators.dart';
import '../../../widgets/custom/custom_elevated_button.dart';
import '../../../widgets/custom/custom_textformfield.dart';
import '../../../widgets/custom/custom_toast.dart';
import '../../../widgets/custom/password_textformfield.dart';
import '../agency_auth/switch_agency_screen.dart';
import 'forget_password_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static const String routeName = '/signin';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final FocusNode passNode = FocusNode();
  bool _isLoading = false;
  final double bigCircle = 140;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Form(
        key: _key,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: CircleAvatar(
                radius: bigCircle,
                backgroundColor: Colors.black12.withOpacity(0.03),
                child: CircleAvatar(
                  radius: bigCircle - 40,
                  backgroundColor: Colors.black12.withOpacity(0.03),
                  child: SizedBox(
                    height: 120,
                    child: Image.asset(
                      Provider.of<AppThemeProvider>(context).isDarkMode
                          ? AppImages.logoWhite
                          : AppImages.logoBlack,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: bigCircle * 1.8,
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 32,
                        child: FittedBox(
                          child: Text(
                            'Welcome Back!',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Text(
                        'Enter your email and password to login',
                        style:
                            TextStyle(color: Theme.of(context).disabledColor),
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _email,
                        hint: 'Email: Ex. example@domain.com',
                        autoFocus: true,
                        readOnly: _isLoading,
                        keyboardType: TextInputType.emailAddress,
                        validator: (String? value) =>
                            CustomValidator.email(value),
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(passNode),
                      ),
                      PasswordTextFormField(
                        controller: _password,
                        focusNode: passNode,
                        onFieldSubmitted: (_) => onSignIn(),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: onForgetPassword,
                          child: const Text('Forget password?'),
                        ),
                      ),
                      CustomElevatedButton(
                        title: 'Sign In'.toUpperCase(),
                        isLoading: _isLoading,
                        onTap: onSignIn,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: RichText(
                          text: TextSpan(
                              style: Theme.of(context).textTheme.bodySmall,
                              children: <TextSpan>[
                                const TextSpan(
                                    text: '''Don't have any account? '''),
                                TextSpan(
                                  text: 'Register here',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.of(context)
                                        .pushNamed(SignUpScreen.routeName),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onSignIn() async {
    try {
      if (!_key.currentState!.validate()) return;
      setState(() {
        _isLoading = true;
      });
      final User? user = await AuthMethods()
          .loginWithEmailAndPassword(_email.text, _password.text);
      if (user == null) throw ('User not found');
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
          SwitchAgencyScreen.routeName, (Route<dynamic> route) => false);
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> onForgetPassword() async {
    try {
      final String? isEmailCorrect = CustomValidator.email(_email.text.trim());
      if (isEmailCorrect != null) throw 'Invalid Email';
      final bool sended =
          await AuthMethods().forgetPassword(_email.text.trim());
      if (!sended) throw 'Request fail';
      if (!mounted) return;
      Navigator.of(context).pushNamed(ForgetPasswordScreen.routeName);
    } catch (e) {
      CustomToast.errorToast(message: e.toString());
    }
  }
}
