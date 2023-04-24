import 'package:flutter/material.dart';
import 'package:casper/utilities/utilites.dart';

class SearchTextField extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final textEditingController, hintText, width;

  const SearchTextField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xff000000)),
        color: const Color(0xff545161),
      ),
      child: TextField(
        obscureText: false,
        controller: textEditingController,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        style: SafeGoogleFont(
          'Ubuntu',
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.2175,
          color: Colors.white,
        ),
      ),
    );
  }
}
