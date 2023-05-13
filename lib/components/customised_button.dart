import 'package:flutter/material.dart';
import 'package:casper/utilities/utilites.dart';

class CustomisedButton extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final width, height, text, onPressed, elevation;
  const CustomisedButton({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.onPressed,
    this.elevation = 10,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff12141D),
        elevation: elevation,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: (text is String)
              ? Text(
                  text,
                  style: SafeGoogleFont(
                    'Ubuntu',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1.2175,
                    color: const Color(0xffffffff),
                  ),
                )
              : text,
        ),
      ),
    );
  }
}
