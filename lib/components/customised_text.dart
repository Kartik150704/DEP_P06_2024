import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';

class CustomisedText extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final text, fontSize, color;

  const CustomisedText({
    super.key,
    required this.text,
    this.fontSize = 20,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: SafeGoogleFont(
        'Ubuntu',
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}
