import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_admin_app/auth/login_or_register.dart';
import 'package:job_portal_admin_app/firebase_options.dart';
import 'package:job_portal_admin_app/pages/companies_page.dart';
import 'package:job_portal_admin_app/pages/home_page.dart';
import 'package:job_portal_admin_app/pages/profile_page.dart';
import 'package:job_portal_admin_app/pages/register_page.dart';
import 'package:job_portal_admin_app/theme/dark_mode.dart';
import 'package:job_portal_admin_app/theme/light_mode.dart';

import 'auth/auth.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      theme: lightMode,
      // theme: darkMode,
      darkTheme: darkMode,
      routes: {
        '/profile_page': (context) => ProfilePage(),
        '/login_register_page': (context) => LoginOrRegister(),
        '/home_page': (context) => HomePage(),
        '/profile_page': (context) => ProfilePage(),
        '/companies_page': (context) => CompaniesPage()
      },
    );
  }
}
