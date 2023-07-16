import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'basics.dart';
import 'database/firebase/auth_methods.dart';
import 'database/firebase/notification_api.dart';
import 'database/local/hive_db.dart';
import 'database/local/local_data.dart';
import 'firebase_options.dart';
import 'providers/app_theme_provider.dart';
import 'views/auth/agency_auth/switch_agency_screen.dart';
import 'views/auth/user_auth/sign_in_screen.dart';
import 'views/main_screen/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationAPI().init();
  await HiveDB().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiProvider(
        providers: myProviders,
        child: Consumer<AppThemeProvider>(
          builder: (BuildContext context, AppThemeProvider appPro, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Anon',
              theme: AppThemes.light,
              darkTheme: AppThemes.dark,
              themeMode: appPro.themeMode,
              // TODO: signin time refresh the agencies
              home: AuthMethods.getCurrentUser == null
                  ? const SignInScreen()
                  : LocalData.currentlySelectedAgency() == null
                      ? const SwitchAgencyScreen()
                      : const MainScreen(),
              routes: myRoutes,
            );
          },
        ),
      ),
    );
  }
}

//
// flutter packages pub run build_runner build
// Class Codes
// AppUser -> 1
// Agency -> 2
// Project -> 3
// Chat -> 4
// Messages -> 5
// Board -> 6