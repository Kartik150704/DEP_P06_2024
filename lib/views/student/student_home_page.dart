import 'package:casper/components/customised_sidebar_button.dart';
import 'package:casper/views/shared/loading_page.dart';
import 'package:casper/views/shared/project_page/project_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentHomePage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final selectOption;

  const StudentHomePage({
    Key? key,
    required this.selectOption,
  }) : super(key: key);

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

  void selectCourse(option) {
    setState(() {
      selectedOption = option;
      projectPage = const LoadingPage();
    });

    FirebaseFirestore.instance
        .collection('student')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      setState(() {
        projectPage = ProjectPage(
          projectId: value.docs[0]['proj_id'][option - 1],
          selectOption: widget.selectOption,
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    selectCourse(1);
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = (MediaQuery.of(context).size.width / baseWidth);

    return Row(
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
    );
  }
}
