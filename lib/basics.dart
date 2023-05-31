import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'providers/app_theme_provider.dart';
import 'views/auth/register_agency_screen.dart';

List<SingleChildWidget> myProviders = <SingleChildWidget>[
  ChangeNotifierProvider<AppThemeProvider>.value(value: AppThemeProvider()),
];

//
// Routes
final Map<String, WidgetBuilder> myRoutes = <String, WidgetBuilder>{
  // Auth
  RegisterAgencyScreen.routeName: (_) => const RegisterAgencyScreen(),
};
