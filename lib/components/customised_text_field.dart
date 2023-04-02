import 'package:flutter/material.dart';
import 'package:casper/utilites.dart';

class CustomisedTextField extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final textEditingController, hintText, obscureText, width, margin;

  const CustomisedTextField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.obscureText,
    this.width = double.infinity,
    this.margin = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin),
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xff000000)),
        color: const Color(0xffe1e3e8),
      ),
      child: TextField(
        obscureText: obscureText,
        controller: textEditingController,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xff818488)),
        ),
        style: SafeGoogleFont(
          'Ubuntu',
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.2175,
          color: const Color(0xff000000),
        ),
      ),
    );
  }
}
