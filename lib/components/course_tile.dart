import 'package:casper/components/customised_text.dart';
import 'package:flutter/material.dart';

class CourseTile extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final code, status, details;

  final parameters = [
    'Grade: ',
    'Semester: ',
    'Year: ',
  ];

  CourseTile({
    super.key,
    required this.code,
    required this.status,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = (MediaQuery.of(context).size.width / baseWidth) * 0.97;

    return Container(
      width: 350 * fem,
      height: 250,
      decoration: BoxDecoration(
        color: (status == '0'
            ? Colors.white
            : (status == '1'
                ? const Color(0xfffabb18)
                : const Color(0xff45c646))),
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
            margin: const EdgeInsets.all(5),
            width: 350 * fem,
            height: 80,
            decoration: BoxDecoration(
              color: (status == '0'
                  ? const Color.fromARGB(255, 22, 25, 41)
                  : (status == '1'
                      ? const Color(0xffe0c596)
                      : const Color(0xff7ae37b))),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomisedText(
                text: code +
                    (status == '0'
                        ? ''
                        : (status == '1' ? ' (On-Going)' : ' (Completed)')),
                fontSize: 40,
                color: (status == '0' ? Colors.white : Colors.black),
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
                fontSize: 25,
                color: const Color(0xff3f3f3f),
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
