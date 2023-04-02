import 'package:casper/components/customised_sidebar_button.dart';
import 'package:casper/faculty/faculty_enrollments_page.dart';
import 'package:casper/faculty/panelListPage.dart';
import 'package:flutter/material.dart';

import 'loggedinscaffoldFaculty.dart';

class FacultyHomePage extends StatefulWidget {
  final String role;

  const FacultyHomePage({
    Key? key,
    this.role = 'su',
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
        );
      } else {
        displayPage = PanelPageFaculty(
          role: widget.role,
        );
      }
    });
  }

  void onPressed() {}

  @override
  void initState() {
    super.initState();
    displayPage = FacultyEnrollmentsPage(
      role: widget.role,
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth * 0.97;

    return LoggedInScaffoldFaculty(
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
