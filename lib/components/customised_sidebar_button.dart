import 'package:casper/components/customised_text.dart';
import 'package:flutter/material.dart';

class CustomisedSidebarButton extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final text, isSelected, onPressed;

  CustomisedSidebarButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            isSelected ? const Color(0xff302c42) : null,
          ),
        ),
        onPressed: onPressed,
        child: CustomisedText(
          text: text,
          fontSize: 25,
          selectable: false,
        ),
      ),
    );
  }
}
