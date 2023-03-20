import 'package:casper/components/customised_button.dart';
import 'package:casper/student/logged_in_scaffold_student.dart';
import 'package:casper/student/projectPage.dart';
import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/confirm_action.dart';

class CustomisedText extends StatelessWidget {
  final text, fontSize;

  const CustomisedText({
    super.key,
    required this.text,
    this.fontSize = 20,
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
        color: const Color(0xffffffff),
      ),
    );
  }
}
