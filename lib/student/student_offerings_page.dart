import 'package:casper/components/customised_sidebar_button.dart';
import 'package:casper/student/student_logged_in_scaffold.dart';
import 'package:casper/student/enrollmentRequests.dart';
import 'package:casper/student/student_offerings.dart';
import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';

class StudentOfferingsPage extends StatefulWidget {
  const StudentOfferingsPage({Key? key}) : super(key: key);

  @override
  State<StudentOfferingsPage> createState() => _StudentOfferingsPageState();
}

class _StudentOfferingsPageState extends State<StudentOfferingsPage> {
  var selectedOption, displayedPage;

  var pages = [
    'Available Projects',
    'Enrollment Requests',
  ];

  @override
  void initState() {
    super.initState();
    selectedOption = 1;
    displayedPage = StudentOfferings();
  }

  void selectPage(selectOption) {
    setState(() {
      selectedOption = selectOption;
      displayedPage =
          (selectedOption == 1 ? StudentOfferings() : EnrollmentRequestsPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = (MediaQuery.of(context).size.width / baseWidth) * 0.97;

    return StudentLoggedInScaffold(
      studentScaffoldBody: Row(
        children: [
          Container(
            width: 300 * fem,
            color: const Color(0xff545161),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < pages.length; i++) ...[
                      CustomisedSidebarButton(
                        text: pages[i],
                        isSelected: (selectedOption == (i + 1)),
                        onPressed: () => selectPage(i + 1),
                      )
                    ],
                  ],
                ),
              ],
            ),
          ),
          displayedPage,
        ],
      ),
    );
  }
}
