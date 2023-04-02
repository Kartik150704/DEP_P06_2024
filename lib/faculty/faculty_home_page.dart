import 'package:casper/components/customised_sidebar_button.dart';
import 'package:casper/faculty/faculty_enrollments_page.dart';
import 'package:casper/faculty/panelListPage.dart';
import 'package:casper/student/project_page.dart';
import 'package:flutter/material.dart';

import 'faculty_logged_in_scaffold.dart';

class FacultyHomePage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final role, projectId;

  const FacultyHomePage({
    Key? key,
    this.role = 'su',
    this.projectId = -1,
  }) : super(key: key);

  @override
  State<FacultyHomePage> createState() => _FacultyHomePageState();
}

class _FacultyHomePageState extends State<FacultyHomePage> {
  var options = ['Enrollments', 'Panels'], option = 1;

  dynamic displayPage;

  void selectOption(opt) {
    setState(() {
      option = opt;
      if (option == 1) {
        displayPage = FacultyEnrollmentsPage(
          role: widget.role,
          showProject: showProject,
        );
      } else {
        displayPage = PanelPageFaculty(
          role: widget.role,
        );
      }
    });
  }

  void showProject(projectId) {
    setState(() {
      displayPage = ProjectPage(
        project_id: projectId,
        isFaculty: true,
      );
    });
  }

  void onPressed() {}

  @override
  void initState() {
    super.initState();
    if (widget.projectId != -1) {
      displayPage = ProjectPage(
        project_id: widget.projectId,
        isFaculty: true,
      );
    } else {
      displayPage = FacultyEnrollmentsPage(
        role: widget.role,
        showProject: showProject,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth * 0.97;

    return FacultyLoggedInScaffold(
      role: widget.role,
      scaffoldbody: Row(
        children: [
          Container(
            width: 300 * fem,
            color: const Color(0xff545161),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < options.length; i++) ...[
                      CustomisedSidebarButton(
                        text: options[i],
                        isSelected: (option == (i + 1)),
                        onPressed: () => selectOption(i + 1),
                      )
                    ],
                  ],
                ),
              ],
            ),
          ),
          displayPage,
        ],
      ),
    );
  }
}
