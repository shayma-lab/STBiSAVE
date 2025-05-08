// ignore_for_file: unused_import, duplicate_import

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_first_project/pages/admin/admin.dart';
import 'package:my_first_project/pages/client/objectifs_page.dart';
import 'package:my_first_project/pages/client/tab_screen.dart';
import 'package:my_first_project/pages/home_page.dart';
import 'package:my_first_project/pages/splash_screen.dart';
import 'pages/auth/connexion.dart';
import 'pages/auth/inscription.dart';
import 'pages/client/rapport.dart';
import 'pages/client/acceuil.dart';
import 'pages/client/add_objectif_page.dart';
import 'pages/client/profile.dart';

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
        SplashScreen.routeName: (context) => SplashScreen(),
        LoginPage.routeName: (context) => LoginPage(),
        InscriptionPage.routeName: (context) => InscriptionPage(),
        TabScreen.routeName: (context) => TabScreen(),
        RapportsPage.routeName: (context) => RapportsPage(),
        AddObjectifPage.routeName: (context) => AddObjectifPage(),
        ProfilePage.routeName: (context) => ProfilePage(),
        AcceuilPage.routeName: (context) => AcceuilPage(),
        ObjectifsPage.routeName: (context) => ObjectifsPage(),
        AdminPage.routeName: (context) => AdminPage(),
      },
    );
  }
}
