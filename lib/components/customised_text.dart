import 'package:casper/utilities/utilites.dart';
import 'package:flutter/material.dart';

class CustomisedText extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final text, fontSize, color, selectable;

  const CustomisedText({
    super.key,
    required this.text,
    this.fontSize = 20,
    this.color = Colors.white,
    this.selectable = true,
  });

  @override
  Widget build(BuildContext context) {
    if (selectable) {
      return SelectionArea(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: SafeGoogleFont(
            'Ubuntu',
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      );
    } else {
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
}
