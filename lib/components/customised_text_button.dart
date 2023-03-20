import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';

class CustomisedTextButton extends StatelessWidget {
  final text, onPressed;

  const CustomisedTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: SafeGoogleFont(
          'Ubuntu',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      ),
    );
  }
}
