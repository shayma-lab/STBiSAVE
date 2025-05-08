import 'package:flutter/material.dart';

class InfoMessageWidget extends StatelessWidget {
  final String infoMessage;
  const InfoMessageWidget(this.infoMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        infoMessage,
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }
}
