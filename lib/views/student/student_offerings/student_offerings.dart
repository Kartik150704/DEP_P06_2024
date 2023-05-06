import 'package:casper/components/customised_sidebar_button.dart';
import 'package:casper/views/student/student_offerings/student_enrollment_requests_page.dart';
import 'package:casper/views/student/student_offerings/student_offered_projects_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentOfferings extends StatefulWidget {
  const StudentOfferings({
    Key? key,
  }) : super(key: key);

  @override
  State<StudentOfferings> createState() => _StudentOfferingsState();
}

class _StudentOfferingsState extends State<StudentOfferings> {
  // ignore: prefer_typing_uninitialized_variables
  var selectedOption, displayPage;
  var options = [
    'Offered Projects',
    'Request(s) Status',
  ];

  void selectOption(option) {
    setState(() {
      selectedOption = option;
      switch (option) {
        case 0:
          displayPage = const StudentOfferedProjectsPage();
          break;
        case 1:
          displayPage = const StudentEnrollmentRequestsPage();
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    selectOption(0);
    FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double wfem = (MediaQuery.of(context).size.width / baseWidth);

    return Row(
      children: [
        Container(
          width: 300 * wfem,
          color: const Color(0xff545161),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int i = 0; i < options.length; i++) ...[
                    CustomisedSidebarButton(
                      text: options[i],
                      isSelected: (selectedOption == i),
                      onPressed: () => selectOption(i),
                    )
                  ],
                ],
              ),
            ],
          ),
        ),
        displayPage,
      ],
    );
  }
}
