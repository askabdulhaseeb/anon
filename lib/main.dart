import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'basics.dart';
import 'database/firebase/auth_methods.dart';
import 'database/local/local_agency.dart';
import 'database/local/local_db.dart';
import 'firebase_options.dart';
import 'providers/app_theme_provider.dart';
import 'views/auth/agency_auth/switch_agency_screen.dart';
import 'views/auth/user_auth/sign_in_screen.dart';
import 'views/main_screen/main_screen.dart';
import 'widgets/custom/show_loading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDB().init();
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
                : Scaffold(
                    body: FutureBuilder<bool>(
                      future: LocalAgency().displayMainScreen(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<bool> snapshot,
                      ) {
                        if (snapshot.hasData) {
                          return snapshot.data ?? false
                              ? const MainScreen()
                              : const SwitchAgencyScreen();
                        } else if (snapshot.hasError) {
                          return const SwitchAgencyScreen();
                        } else {
                          return const ShowLoading();
                        }
                      },
                    ),
                  ),
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