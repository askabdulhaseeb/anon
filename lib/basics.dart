import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'providers/app_theme_provider.dart';
import 'views/auth/agency_auth/join_agency_screen.dart';
import 'views/auth/forget_password_screen.dart';
import 'views/auth/agency_auth/register_agency_screen.dart';
import 'views/auth/sign_in_screen.dart';
import 'views/auth/sign_up_screen.dart';
import 'views/main_screen/main_screen.dart';

List<SingleChildWidget> myProviders = <SingleChildWidget>[
  ChangeNotifierProvider<AppThemeProvider>.value(value: AppThemeProvider()),
];

//
// Routes
final Map<String, WidgetBuilder> myRoutes = <String, WidgetBuilder>{
  // Auth
  SignInScreen.routeName: (_) => const SignInScreen(),
  ForgetPasswordScreen.routeName: (_) => const ForgetPasswordScreen(),
  SignUpScreen.routeName: (_) => const SignUpScreen(),
  // Agency
  JoinAgencyScreen.routeName: (_) => const JoinAgencyScreen(),
  RegisterAgencyScreen.routeName: (_) => const RegisterAgencyScreen(),
  // Main
  MainScreen.routeName: (_) => const MainScreen(),
};
