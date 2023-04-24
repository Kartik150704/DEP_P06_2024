import 'package:casper/components/customised_sidebar_button.dart';
import 'package:casper/views/faculty/faculty_offerings/faculty_enrollment_requests_page.dart';
import 'package:casper/views/faculty/faculty_offerings/faculty_offered_projects_page.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FacultyOfferingsPage extends StatefulWidget {
  String userRole;

  FacultyOfferingsPage({
    Key? key,
    required this.userRole,
  }) : super(key: key);

  @override
  State<FacultyOfferingsPage> createState() => _FacultyOfferingsPagePageState();
}

class _FacultyOfferingsPagePageState extends State<FacultyOfferingsPage> {
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
        displayPage = const FacultyEnrollmentRequestsPage();
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
