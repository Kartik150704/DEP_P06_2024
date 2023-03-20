import 'package:casper/components/customised_sidebar_button.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/components/textstyle.dart';
import 'package:casper/student/logged_in_scaffold_student.dart';
import 'package:casper/student/projectPage.dart';
import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  // ignore: prefer_typing_uninitialized_variables
  var selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = 1;
  }

  void onPressed() {}

  ProjectPage projectpage = ProjectPage(
    flag: true,
  );

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = (MediaQuery.of(context).size.width / baseWidth) * 0.97;

    final courses = [
      'CP301',
      'CP302',
      'CP303',
    ];

    void selectCourse(selectOption) {
      setState(() {
        selectedOption = selectOption;
        // TODO INSERT QUERY TO GET PROJECT ID
        projectpage = ProjectPage(
          flag: (selectOption == 1),
        );
      });
    }

    return SelectionArea(
      child: LoggedInScaffoldStudent(
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
            projectpage,
          ],
        ),
      ),
    );
  }
}
