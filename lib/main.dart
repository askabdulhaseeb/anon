import 'package:firebase_core/firebase_core.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'basics.dart';
import 'firebase_options.dart';
import 'providers/app_theme_provider.dart';
import 'views/auth/register_agency_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final String apiKey = DefaultFirebaseOptions.currentPlatform.apiKey;
  final String projectID = DefaultFirebaseOptions.currentPlatform.projectId;
  // final String apiKey =
  //     dotenv.env['AIzaSyB8YhkfXzmYrC_gCRMruV4-N3Ogf_XwEt0'] as String;
  // final String projectID = dotenv.env['dm-managment'] as String;
  Firestore.initialize(projectID);
  FirebaseAuth.initialize(apiKey, VolatileStore());
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
            home: const RegisterAgencyScreen(),
          );
        },
      ),
    );
  }
}

//
// flutter packages pub run build_runner build