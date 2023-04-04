import 'package:casper/components/customised_sidebar_button.dart';
import 'package:casper/student/student_enrollment_requests.dart';
import 'package:casper/student/student_logged_in_scaffold.dart';
import 'package:casper/student/student_offerings.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentOfferingsPage extends StatefulWidget {
  const StudentOfferingsPage({Key? key}) : super(key: key);

  @override
  State<StudentOfferingsPage> createState() => _StudentOfferingsPageState();
}

class _StudentOfferingsPageState extends State<StudentOfferingsPage> {
  // ignore: prefer_typing_uninitialized_variables
  var selectedOption, displayedPage;
  var uid;
  var pages = [
    'Available Projects',
    'Enrollment Requests',
  ];

  @override
  void initState() {
    super.initState();
    selectedOption = 1;
    displayedPage = const StudentOfferings();
    uid = FirebaseAuth.instance.currentUser?.uid;
  }

  void selectPage(selectOption) {
    setState(() {
      selectedOption = selectOption;
      displayedPage = (selectedOption == 1
          ? const StudentOfferings()
          : const StudentEnrollmentRequests());
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = (MediaQuery.of(context).size.width / baseWidth) * 0.97;

    return StudentLoggedInScaffold(
      uid: uid,
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
