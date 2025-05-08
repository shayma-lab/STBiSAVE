import 'package:flutter/material.dart';

PreferredSizeWidget backAppBar(BuildContext context, String text) {
  return AppBar(
      backgroundColor: Color(0xFF3C8CE7),
      centerTitle: true,
      title: Text(
        text,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          size: 20,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      elevation: 0);
}
