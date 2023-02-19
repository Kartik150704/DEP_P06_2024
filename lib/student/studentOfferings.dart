import 'package:casper/student/loggedinscaffoldStudent.dart';
import 'package:casper/student/projectPage.dart';
import 'package:casper/student/enrollmentRequests.dart';
import 'package:casper/student/offeringspageStudent.dart';
import 'package:casper/utils.dart';
import 'package:flutter/material.dart';

class StudentOfferings extends StatefulWidget {
  const StudentOfferings({Key? key}) : super(key: key);

  @override
  State<StudentOfferings> createState() => _StudentOfferingsState();
}

class _StudentOfferingsState extends State<StudentOfferings> {
  void onPressed() {}
  dynamic shownpage = OfferingsPageStudent();

  @override
  Widget build(BuildContext context) {
    return LoggedInScaffoldStudent(
      scaffoldbody: Row(
        children: [
          Container(
            width: 300,
            color: Color(0xff545161),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 80,
                      child: TextButton(
                        onPressed: () {
                          setState(
                            () {
                              shownpage = OfferingsPageStudent();
                            },
                          );
                        },
                        child: Text(
                          'Projects',
                          style: SafeGoogleFont(
                            'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      child: TextButton(
                        onPressed: () {
                          setState(
                            () {
                              shownpage = const EnrollmentRequestsPage();
                            },
                          );
                        },
                        child: Text(
                          'Enrollment Requests',
                          style: SafeGoogleFont(
                            'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
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
