import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AlertMessage extends StatelessWidget {
  String message;

  AlertMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SizedBox(
        width: 400,
        height: 50,
        child: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
