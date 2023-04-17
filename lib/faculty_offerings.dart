import 'package:casper/components/customised_sidebar_button.dart';
import 'package:casper/enrollmentRequestsFaculty.dart';
import 'package:casper/views/faculty/faculty_offered_projects_page.dart';
import 'package:flutter/material.dart';

class FacultyOfferings extends StatefulWidget {
  final role;

  const FacultyOfferings({Key? key, required this.role}) : super(key: key);

  @override
  State<FacultyOfferings> createState() => _FacultyOfferingsPageState();
}

class _FacultyOfferingsPageState extends State<FacultyOfferings> {
  var option = 1;
  dynamic displayPage;
  var options = [
    'Projects',
    'Enrollment Requests',
  ];

  void selectOption(opt) {
    setState(() {
      option = opt;
      if (option == 1) {
        displayPage = const FacultyOfferedProjectsPage();
      } else {
        displayPage = const EnrollmentRequestsPageFaculty();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    displayPage = const FacultyOfferedProjectsPage();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth;
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
    );
  }
}
