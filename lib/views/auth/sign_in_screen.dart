import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_theme_provider.dart';
import '../../utilities/app_images.dart';
import '../../utilities/custom_validators.dart';
import '../../widgets/custom/custom_elevated_button.dart';
import '../../widgets/custom/custom_textformfield.dart';
import '../../widgets/custom/password_textformfield.dart';
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
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: SizedBox(
                    height: 120,
                    child: Image.asset(
                      Provider.of<AppThemeProvider>(context).isDarkMode
                          ? AppImages.logoWhite
                          : AppImages.logoBlack,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 32,
                  child: FittedBox(
                    child: Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Enter your email and password to login',
                  style: TextStyle(color: Theme.of(context).disabledColor),
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _email,
                  hint: 'Email: Ex. example@domain.com',
                  autoFocus: _isLoading,
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) => CustomValidator.email(value),
                ),
                PasswordTextFormField(controller: _password),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Forget password?'),
                  ),
                ),
                CustomElevatedButton(
                  title: 'Sign In',
                  onTap: () async {},
                ),
                const SizedBox(height: 16),
                Center(
                  child: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.bodySmall,
                        children: <TextSpan>[
                          const TextSpan(text: '''Don't have any account? '''),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
