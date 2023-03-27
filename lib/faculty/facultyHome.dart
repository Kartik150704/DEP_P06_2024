import 'package:casper/components/customised_sidebar_button.dart';
import 'package:casper/faculty/enrollmentsPageFaculty.dart';
import 'package:casper/faculty/panelListPage.dart';
import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';

import 'loggedinscaffoldFaculty.dart';

class FacultyHome extends StatefulWidget {
  final role;

  const FacultyHome({Key? key, this.role = 'su'}) : super(key: key);

  @override
  State<FacultyHome> createState() => _FacultyHomeState();
}

class _FacultyHomeState extends State<FacultyHome> {
  void onPressed() {}
  dynamic shownpage;
  var option;

  var options = ['Enrollments', 'Panels'];

  void selectOption(opt) {
    setState(() {
      option = opt;
      if (option == 1) {
        shownpage = EnrollmentsPageFaculty(
          role: widget.role,
        );
      } else {
        shownpage = PanelPageFaculty(
          role: widget.role,
        );
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    option = 1;
    shownpage = EnrollmentsPageFaculty(
      role: widget.role,
    );
  }

  @override
  Widget build(BuildContext context) {
    // setState(
    //   () {
    //     shownpage = EnrollmentsPageFaculty(
    //       role: widget.role,
    //     );
    //   },
    // );
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth * 0.97;
    return LoggedInScaffoldFaculty(
      role: widget.role,
      scaffoldbody: Row(
        children: [
          Container(
            width: 300 * fem,
            color: Color(0xff545161),
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
          shownpage,
        ],
      ),
    );
  }
}
