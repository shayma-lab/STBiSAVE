// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:my_first_project/pages/client/acceuil.dart';
import 'package:my_first_project/pages/client/objectif/objectifs_page.dart';
import 'package:my_first_project/pages/client/profile.dart';
import 'package:my_first_project/pages/client/rapport.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});
  static const routeName = "/TabScreen";

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int currentIndex = 0;
  late List<Widget> children;
  bool printerLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    children = [
      AcceuilPage(),
      RapportsPage(),
      ObjectifsPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: currentIndex,
              children: children,
            ),
          ],
        ),
        bottomNavigationBar: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withValues(alpha: 0.1),
                  )
                ],
              ),
              child: GNav(
                  tabBorderRadius: 16,
                  activeColor: Color(0xFF005A9C),
                  tabBackgroundColor: Color(0xFF005A9C),
                  padding: EdgeInsets.all(10),
                  iconSize: 22,
                  onTabChange: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  gap: 8,
                  tabs: [
                    GButton(
                      icon: FontAwesomeIcons.buildingColumns,
                      text: 'Acceuil',
                      iconColor: Color(0xFF005A9C),
                      iconActiveColor: Colors.white,
                      textColor: Colors.white,
                    ),
                    GButton(
                      icon: FontAwesomeIcons.chartColumn,
                      text: 'Statistiques',
                      iconColor: Color(0xFF005A9C),
                      iconActiveColor: Colors.white,
                      textColor: Colors.white,
                    ),
                    GButton(
                      icon: FontAwesomeIcons.piggyBank,
                      text: 'Objectifs',
                      iconColor: Color(0xFF005A9C),
                      iconActiveColor: Colors.white,
                      textColor: Colors.white,
                    ),
                    GButton(
                      icon: FontAwesomeIcons.user,
                      text: 'Profil',
                      iconColor: Color(0xFF005A9C),
                      iconActiveColor: Colors.white,
                      textColor: Colors.white,
                    ),
                  ]),
            ),
            if (printerLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              ),
          ],
        ));
  }
}
