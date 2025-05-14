// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomSheetCamera extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback onPressed2;
  BottomSheetCamera(this.onPressed, this.onPressed2);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text("Choisissez votre photo:",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                  onPressed: onPressed,
                  icon: Icon(
                    FontAwesomeIcons.camera,
                    color: Colors.white,
                  ),
                  label: Text("Appareil photo",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white))),
              TextButton.icon(
                  onPressed: onPressed2,
                  icon: Icon(
                    FontAwesomeIcons.image,
                    color: Colors.white,
                  ),
                  label: Text("Galerie",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white))),
            ],
          )
        ],
      ),
    );
  }
}
