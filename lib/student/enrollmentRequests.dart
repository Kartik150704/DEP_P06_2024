import 'package:flutter/material.dart';
import 'package:casper/components/confirm_action.dart';

import '../components/projecttile.dart';
import '../utilites.dart';

class EnrollmentRequestsPage extends StatefulWidget {
  const EnrollmentRequestsPage({Key? key}) : super(key: key);

  @override
  State<EnrollmentRequestsPage> createState() => _EnrollmentRequestsPageState();
}

class _EnrollmentRequestsPageState extends State<EnrollmentRequestsPage> {
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
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Expanded(
      child: Container(
        color: const Color(0xff302c42),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Text(
                        'Enrollment Requests',
                        style: SafeGoogleFont(
                          'Ubuntu',
                          fontSize: 50,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xffffffff),
                        ),
                      ),
                    ),
                  ],
                ),
                ProjectTile(
                  info:
                      'Supervisor Name - NAME\nSemester - SEMESTER\nYear - YEAR\nProject Description - DESCRIPTION',
                  title: 'Project Title',
                  type: 'CP303',
                  status: '(Rejected)',
                  theme: 'r',
                ),
                ProjectTile(
                  info:
                      'Supervisor Name - NAME\nSemester - SEMESTER\nYear - YEAR\nProject Description - DESCRIPTION',
                  title: 'Project Title',
                  type: 'CP303',
                  button_text: 'Apply Now',
                  status: '(Accepted)',
                  theme: 'g',
                ),
                ProjectTile(
                  info:
                      'Supervisor Name - NAME\nSemester - SEMESTER\nYear - YEAR\nProject Description - DESCRIPTION',
                  title: 'Project Title',
                  type: 'CP303',
                  button_flag: true,
                  button_onPressed: confirmAction,
                  button_text: 'Cancel',
                  status: '(Pending)',
                  theme: 'w',
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
