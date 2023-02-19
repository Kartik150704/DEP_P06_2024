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
    return Expanded(
      child: Container(
          color: Color(0xff302c42),
          child: ListView(
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
            ],
          )),
    );
  }
}
