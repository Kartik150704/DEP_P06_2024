import 'package:flutter/material.dart';

import '../utils.dart';

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
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    const buttonColor = Color(0xff1a1d2d);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Container(
        width: 127 * fem,
        height: 43 * fem,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10 * fem),
          boxShadow: [
            BoxShadow(
              color: buttonColor,
              offset: Offset(0 * fem, 4 * fem),
            ),
          ],
        ),
        child: Center(
          child: Text(
            buttonText,
            style: SafeGoogleFont(
              'Montserrat',
              fontSize: 13 * ffem,
              fontWeight: FontWeight.w700,
              height: 1.2175 * ffem / fem,
              color: Color(0xffe1e3e8),
            ),
          ),
        ),
      ),
    );
  }
}
