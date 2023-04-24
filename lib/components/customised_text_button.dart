import 'package:casper/utilities/utilites.dart';
import 'package:flutter/material.dart';

class CustomisedTextButton extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
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
