import 'package:casper/components/customised_text.dart';
import 'package:flutter/material.dart';

class CourseTile extends StatelessWidget {
  final code, status, details;

  final parameters = ['Grade: ', 'Semester: ', 'Year: '];

  CourseTile({
    super.key,
    required this.code,
    required this.status,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 300,
      decoration: BoxDecoration(
        color: (status == '1' ? const Color(0xfffabb18) : Color(0xff45c646)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 3,
            blurRadius: 20,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 500,
            height: 100,
            decoration: BoxDecoration(
              color: (status == '1' ? Color(0xffe0c596) : Color(0xff7ae37b)),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: CustomisedText(
                text: code + (status == '1' ? '(On Going)' : '(Completed)'),
                fontSize: 45,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          for (int i = 0; i < parameters.length; i++) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
              child: CustomisedText(
                text: parameters[i] + details[i],
                fontSize: 30,
                color: Color(0xff3f3f3f),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ]
        ],
      ),
    );
  }
}
