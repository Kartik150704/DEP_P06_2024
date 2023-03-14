import 'package:flutter/material.dart';

import '../utilites.dart';

class CustomTextField extends StatelessWidget {
  final texteditingcontroller, hinttext;
  bool obscure = false;
  CustomTextField({
    Key? key,
    required TextEditingController this.texteditingcontroller,
    required this.hinttext,
    this.obscure = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        // frame715hu (225:177)
        // margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 13 * fem),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10 * fem),
          border: Border.all(color: Color(0xff000000)),
          color: Color(0xffe1e3e8),
        ),
        child: TextField(
          obscureText: obscure,
          controller: texteditingcontroller,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.fromLTRB(15 * fem, 10 * fem, 15 * fem, 10 * fem),
            hintText: hinttext,
            hintStyle: TextStyle(color: Color(0xff676767)),
          ),
          style: SafeGoogleFont(
            'Montserrat',
            fontSize: 15 * ffem,
            fontWeight: FontWeight.w400,
            height: 1.2175 * ffem / fem,
            color: Color(0xff000000),
          ),
        ),
      ),
    );
  }
}
