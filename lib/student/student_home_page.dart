import 'package:casper/components/customised_sidebar_button.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/student/no_projects_found_page.dart';
import 'package:casper/student/student_logged_in_scaffold.dart';
import 'package:casper/student/project_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  // ignore: prefer_typing_uninitialized_variables
  var selectedOption, projectPage;

  var courses = [
    'CP301',
    'CP302',
    'CP303',
  ];
  var projectDetails = [
    'Fair Clustering Algorithms',
    'Dr. Shweta Jain',
    '2023',
    'II',
    ['Ojassvi Kumar', 'Aman Kumar'],
  ];

  @override
  void initState() {
    super.initState();
    selectedOption = 1;
    projectPage = NoProjectsFoundPage();
    FirebaseFirestore.instance
        .collection('student')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      fetchProject(value.docs[0]['proj_id'][selectedOption - 1]);
    });
    // projectPage = Text('hi');
  }

  fetchProject(var project_id) {
    setState(() {
      projectPage = ProjectPage(
        project_id: project_id,
      );
    });
  }

  void selectCourse(selectOption) {
    setState(() {
      selectedOption = selectOption;
    });
    FirebaseFirestore.instance
        .collection('student')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      fetchProject(value.docs[0]['proj_id'][selectOption - 1]);
    });
  }

  void onPressed() {}

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
                    for (int i = 0; i < courses.length; i++) ...[
                      CustomisedSidebarButton(
                        text: courses[i],
                        isSelected: (selectedOption == (i + 1)),
                        onPressed: () => selectCourse(i + 1),
                      )
                    ],
                  ],
                ),
              ],
            ),
          ),
          projectPage,
        ],
      ),
    );
  }
}
