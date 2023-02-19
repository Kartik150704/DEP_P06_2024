import 'package:flutter/material.dart';

import '../components/projecttile.dart';

class EnrollmentRequestsPageFaculty extends StatelessWidget {
  const EnrollmentRequestsPageFaculty({Key? key}) : super(key: key);

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
                button_onPressed: () {},
                button2_flag: true,
                button2_text: 'Reject',
                button2_onPressed: () {},
              ),
            ],
          )),
    );
  }
}
