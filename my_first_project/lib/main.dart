// ignore_for_file: unused_import, duplicate_import

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_first_project/pages/home_page.dart';
import 'package:my_first_project/pages/splash_screen.dart';
import 'pages/auth/connexion.dart';
import 'pages/auth/inscription.dart';
import 'pages/rapport.dart';
import 'pages/acceuil.dart';
import 'pages/objectif.dart';
import 'pages/profile.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginPage(),
        '/splash': (context) => SplashScreen(),
        '/register': (context) => InscriptionPage(),
        '/rapport': (context) => RapportsPage(),
        '/objectif': (context) => ObjectifPage(),
        '/compte': (context) => ProfilePage(),
        '/home': (context) => AcceuilPage(),
      },
    );
  }
}
