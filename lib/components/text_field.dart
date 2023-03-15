import 'package:flutter/material.dart';
import 'package:casper/utilites.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xff000000)),
          color: const Color(0xffe1e3e8),
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
            contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            hintText: hinttext,
            hintStyle: const TextStyle(color: Color(0xff676767)),
          ),
          style: SafeGoogleFont(
            'Ubuntu',
            fontSize: 15,
            fontWeight: FontWeight.w400,
            height: 1.2175,
            color: const Color(0xff000000),
          ),
        ),
      ),
    );
  }
}
