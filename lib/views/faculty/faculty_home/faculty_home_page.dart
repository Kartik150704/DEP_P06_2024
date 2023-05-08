import 'package:casper/comp/add_event_form.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_sidebar_button.dart';
import 'package:casper/views/faculty/faculty_home/coordinator/coordinator_criteria_management_page.dart';
import 'package:casper/views/faculty/faculty_home/faculty_enrollments_page.dart';
import 'package:casper/views/faculty/faculty_home/coordinator/coordinator_panel_management_page.dart';
import 'package:casper/views/faculty/faculty_home/faculty_panel_teams_page.dart';
import 'package:casper/views/faculty/faculty_home/faculty_panels_page.dart';
import 'package:casper/views/shared/project_page/project_page.dart';
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

  void addEvent() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Center(
            child: AddEventForm(
              events: [
                'Week 3',
                'MidTerm',
                'EndTerm',
              ],
            ),
          ),
        );
      },
    );
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
    double wfem = (MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio) /
        baseWidth;

    return Row(
      children: [
        SizedBox(
          width: 300 * wfem,
          child: Scaffold(
            body: Container(
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: (widget.userRole == 'co'
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomisedButton(
                        width: 200 * wfem,
                        height: 60,
                        text: 'Create Event',
                        onPressed: addEvent,
                      ),
                      const SizedBox(
                        height: 55,
                      ),
                    ],
                  )
                : null),
          ),
        ),
        displayPage,
      ],
    );
  }
}
