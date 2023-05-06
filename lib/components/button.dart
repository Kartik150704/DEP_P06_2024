import 'package:flutter/material.dart';

import '../utilities/utilites.dart';

class CustomButton extends StatelessWidget {
  final buttonText, onPressed;

  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double wfem = (MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio) /
        baseWidth;
    double fwfem = wfem * 0.97;
    const buttonColor = Color(0xff1a1d2d);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Container(
        width: 127 * wfem,
        height: 43 * wfem,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10 * wfem),
          boxShadow: [
            BoxShadow(
              color: buttonColor,
              offset: Offset(0 * wfem, 4 * wfem),
            ),
          ],
        ),
        child: Center(
          child: Text(
            buttonText,
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 13 * fwfem,
              fontWeight: FontWeight.w700,
              height: 1.2175 * fwfem / wfem,
              color: Color(0xffe1e3e8),
            ),
          ),
        ),
      ),
    );
  }
}
