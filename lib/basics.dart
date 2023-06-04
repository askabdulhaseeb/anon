import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'providers/app_nav_provider.dart';
import 'providers/app_theme_provider.dart';
import 'views/auth/agency_auth/agency_welcome_screen.dart';
import 'views/auth/agency_auth/join_agency_screen.dart';
import 'views/auth/agency_auth/switch_agency_screen.dart';
import 'views/auth/forget_password_screen.dart';
import 'views/auth/agency_auth/start_agency_screen.dart';
import 'views/auth/sign_in_screen.dart';
import 'views/auth/sign_up_screen.dart';
import 'views/main_screen/main_screen.dart';

List<SingleChildWidget> myProviders = <SingleChildWidget>[
  ChangeNotifierProvider<AppThemeProvider>.value(value: AppThemeProvider()),
  ChangeNotifierProvider<AppNavProvider>.value(value: AppNavProvider()),
];

//
// Routes
final Map<String, WidgetBuilder> myRoutes = <String, WidgetBuilder>{
  // Auth
  SignInScreen.routeName: (_) => const SignInScreen(),
  ForgetPasswordScreen.routeName: (_) => const ForgetPasswordScreen(),
  SignUpScreen.routeName: (_) => const SignUpScreen(),
  // Agency Auth
  JoinAgencyScreen.routeName: (_) => const JoinAgencyScreen(),
  StartAgencyScreen.routeName: (_) => const StartAgencyScreen(),
  AgencyWelcomeScreen.routeName: (_) => const AgencyWelcomeScreen(),
  SwitchAgencyScreen.routeName: (_) => const SwitchAgencyScreen(),
  // Main
  MainScreen.routeName: (_) => const MainScreen(),
  // Project

};
