import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'basics.dart';
import 'database/firebase/auth_methods.dart';
import 'firebase_options.dart';
import 'providers/app_theme_provider.dart';
import 'views/auth/agency_auth/join_agency_screen.dart';
import 'views/auth/sign_in_screen.dart';
import 'views/main_screen/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: myProviders,
      child: Consumer<AppThemeProvider>(
        builder: (BuildContext context, AppThemeProvider appPro, _) {
          return MaterialApp(
            title: 'Dev Markaz',
            theme: AppThemes.light,
            darkTheme: AppThemes.dark,
            themeMode: appPro.themeMode,
            home: AuthMethods.getCurrentUser == null
                ? const SignInScreen()
                : const JoinAgencyScreen(),
            routes: myRoutes,
          );
        },
      ),
    );
  }
}

//
// flutter packages pub run build_runner build
// Class Codes
// AppUser -> 1
// Agency -> 2