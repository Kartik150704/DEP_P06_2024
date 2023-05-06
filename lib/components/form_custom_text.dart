import 'package:flutter/material.dart';

import '../utilities/utilites.dart';

class FormCustomText extends StatelessWidget {
  final String text;

  const FormCustomText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: SafeGoogleFont(
        'Ubuntu',
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: const Color(0xff000000),
      ),
    );
  }
}
