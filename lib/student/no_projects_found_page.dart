import 'package:casper/components/customised_text.dart';
import 'package:casper/student/student_offerings_page.dart';
import 'package:flutter/material.dart';

class NoProjectsFoundPage extends StatelessWidget {
  const NoProjectsFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: const Color(0xff302c42),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomisedText(
              text: 'No project enrollment found for this course',
              fontSize: 45,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const StudentOfferingsPage(),
                            ),
                          )
                        },
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
