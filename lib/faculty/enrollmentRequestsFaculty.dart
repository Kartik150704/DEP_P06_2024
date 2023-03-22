import 'package:flutter/material.dart';
import 'package:casper/components/confirm_action.dart';

import '../components/projecttile.dart';

class EnrollmentRequestsPageFaculty extends StatefulWidget {
  const EnrollmentRequestsPageFaculty({Key? key}) : super(key: key);

  @override
  State<EnrollmentRequestsPageFaculty> createState() =>
      _EnrollmentRequestsPageFacultyState();
}

class _EnrollmentRequestsPageFacultyState
    extends State<EnrollmentRequestsPageFaculty> {
  void confirmAction() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: ConfirmAction(
              onSubmit: () {},
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth * 0.97;
    return Expanded(
      child: Container(
          color: Color(0xff302c42),
          child: ListView(
            children: [
              Container(
                height: 800,
                width: 1200 * fem,
                margin: EdgeInsets.fromLTRB(60, 30, 100 * fem, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                    ),
                    BoxShadow(
                      color: Color.fromARGB(255, 70, 67, 83),
                      spreadRadius: -3,
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ProjectTile(
                          info:
                              'Student Name(s) - STUDENT 1, STUDENT 2\nSemester - SEMESTER\nYear - YEAR\nProject Description - DESCRIPTION',
                          title: 'Project Title',
                          type: 'CP303',
                          theme: 'w',
                          button_flag: true,
                          button_text: 'Accept',
                          button_onPressed: confirmAction,
                          button2_flag: true,
                          button2_text: 'Reject',
                          button2_onPressed: confirmAction,
                        ),
                        ProjectTile(
                          info:
                              'Student Name(s) - STUDENT 1, STUDENT 2\nSemester - SEMESTER\nYear - YEAR\nProject Description - DESCRIPTION',
                          title: 'Project Title',
                          type: 'CP303',
                          theme: 'w',
                          button_flag: true,
                          button_text: 'Accept',
                          button_onPressed: confirmAction,
                          button2_flag: true,
                          button2_text: 'Reject',
                          button2_onPressed: confirmAction,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
