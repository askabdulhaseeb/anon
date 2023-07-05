import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_nav_provider.dart';
import 'providers/app_theme_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/new_project_provider.dart';
import 'views/agency_screens/agency_details_screen.dart';
import 'views/agency_screens/agency_joining_request_screen.dart';
import 'views/auth/agency_auth/agency_welcome_screen.dart';
import 'views/auth/agency_auth/join_agency_screen.dart';
import 'views/auth/agency_auth/switch_agency_screen.dart';
import 'views/auth/user_auth/forget_password_screen.dart';
import 'views/auth/agency_auth/start_agency_screen.dart';
import 'views/auth/user_auth/sign_in_screen.dart';
import 'views/auth/user_auth/sign_up_screen.dart';
import 'views/chat_screens/chat_detail_screen.dart';
import 'views/chat_screens/chat_screen.dart';
import 'views/chat_screens/create_chat_screen.dart';
import 'views/chat_screens/message_media__full_screen.dart';
import 'views/main_screen/main_screen.dart';
import 'views/project_screens/create_project_screen.dart';
import 'views/chat_screens/chat_dashboard_screen.dart';
import 'views/project_screens/project_detail_screen.dart';
import 'views/user_screen/user_profile_screen.dart';

final List<ChangeNotifierProvider<ChangeNotifier>> myProviders =
    <ChangeNotifierProvider<ChangeNotifier>>[
  ChangeNotifierProvider<AppThemeProvider>.value(value: AppThemeProvider()),
  ChangeNotifierProvider<AppNavProvider>.value(value: AppNavProvider()),
  ChangeNotifierProvider<NewProjectProvider>.value(value: NewProjectProvider()),
  ChangeNotifierProvider<ChatProvider>.value(value: ChatProvider()),
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
  // Agency
  AgencyDetailsScreen.routeName: (_) => const AgencyDetailsScreen(),
  AgencyJoiningRequestScreen.routeName: (_) =>
      const AgencyJoiningRequestScreen(),
  // Project
  CreateProjectScreen.routeName: (_) => const CreateProjectScreen(),
  ProjectDashboardScreen.routeName: (_) => const ProjectDashboardScreen(),
  ProjectDetailScreen.routeName: (_) => const ProjectDetailScreen(),
  // Chat
  CreateChatScreen.routeName: (_) => const CreateChatScreen(),
  ChatScreen.routeName: (_) => const ChatScreen(),
  ChatDetailScreen.routeName: (_) => const ChatDetailScreen(),
  MessageMediaFullScreen.routeName: (_) => const MessageMediaFullScreen(),
  // User
  UserProfileScreeen.routeName: (_) => const UserProfileScreeen(),
};
