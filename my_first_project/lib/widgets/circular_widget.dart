import 'package:flutter/material.dart';

class CircularWidget extends StatelessWidget {
  final Color color;
  const CircularWidget(this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      color: color,
    ));
  }
}
