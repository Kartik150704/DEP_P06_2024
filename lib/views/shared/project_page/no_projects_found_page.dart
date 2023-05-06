import 'package:casper/comp/customised_text.dart';
import 'package:flutter/material.dart';

class NoProjectsFoundPage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final selectOption;

  const NoProjectsFoundPage({
    super.key,
    required this.selectOption,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: const Color(0xff302c42),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomisedText(
              text: 'No enrollments found for this course',
              fontSize: 45,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () => selectOption(2),
                    child: const CustomisedText(
                      text: 'Click Here',
                      fontSize: 40,
                      color: Colors.blue,
                      selectable: false,
                    )),
                const CustomisedText(
                  text: 'to view available offerings',
                  fontSize: 40,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
