import 'package:flutter/material.dart';

PreferredSizeWidget appBar(BuildContext context, String text) {
  return AppBar(
      backgroundColor: Color(0xFF3C8CE7),
      title: Text(
        text,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
      ),
      centerTitle: true,
      leading: SizedBox(),
      elevation: 0);
}
