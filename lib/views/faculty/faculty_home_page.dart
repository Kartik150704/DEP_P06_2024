import 'package:casper/components/customised_sidebar_button.dart';
import 'package:casper/views/faculty/coordinator/coordinator_criteria_management_page.dart';
import 'package:casper/views/faculty/faculty_enrollments_page.dart';
import 'package:casper/views/faculty/coordinator/coordinator_panel_management_page.dart';
import 'package:casper/views/faculty/faculty_panel_teams_page.dart';
import 'package:casper/views/faculty/faculty_panels_page.dart';
import 'package:casper/views/shared/project_page.dart';
import 'package:flutter/material.dart';

class FacultyHomePage extends StatefulWidget {
  final int projectId;
  final String userRole;

  const FacultyHomePage({
    Key? key,
    this.projectId = -1,
    required this.userRole,
  }) : super(key: key);

  @override
  State<FacultyHomePage> createState() => _FacultyHomePageState();
}

class _FacultyHomePageState extends State<FacultyHomePage> {
  int selectedOption = 0;
  dynamic displayPage;
  var options = [
    'My Enrollments',
    'My Panels',
  ];

  void viewProject(projectId) {
    setState(() {
      displayPage = ProjectPage(
        projectId: projectId,
        isFaculty: true,
      );
    });
  }

  void viewPanel(assignedPanel, actionType) {
    setState(() {
      displayPage = FacultyPanelTeamsPage(
        actionType: actionType,
        userRole: widget.userRole,
        assignedPanel: assignedPanel,
      );
    });
  }

  void selectOption(option) {
    setState(() {
      selectedOption = option;
      switch (option) {
        case 0:
          displayPage = FacultyEnrollmentsPage(
            userRole: widget.userRole,
            viewProject: viewProject,
          );
          break;
        case 1:
          displayPage = FacultyPanelsPage(
            userRole: widget.userRole,
            viewPanel: viewPanel,
          );
          break;
        case 2:
          displayPage = CoordinatorPanelManagementPage(
            userRole: widget.userRole,
            viewPanel: viewPanel,
          );
          break;
        case 3:
          displayPage = CoordinatorCriteriaManagementPage(
            userRole: widget.userRole,
            viewCritera: () {},
          );
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.userRole == 'co') {
      options = [
        'My Enrollments',
        'My Panels',
        'Panel Management',
        'Criteria Management',
      ];
    }

    displayPage = FacultyEnrollmentsPage(
      userRole: widget.userRole,
      viewProject: viewProject,
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth * 0.97;

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
                  for (int i = 0; i < options.length; i++) ...[
                    CustomisedSidebarButton(
                      text: options[i],
                      isSelected: (selectedOption == (i)),
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
