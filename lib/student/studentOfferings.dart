import 'package:casper/student/logged_in_scaffold_student.dart';
import 'package:casper/student/enrollmentRequests.dart';
import 'package:casper/student/offeringspageStudent.dart';
import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';

class StudentOfferings extends StatefulWidget {
  const StudentOfferings({Key? key}) : super(key: key);

  @override
  State<StudentOfferings> createState() => _StudentOfferingsState();
}

class _StudentOfferingsState extends State<StudentOfferings> {
  void onPressed() {}
  var option;
  dynamic shownpage = OfferingsPageStudent();

  @override
  void initState() {
    super.initState();
    option = 1;
  }

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
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              option == 1 ? const Color(0xff302c42) : null),
                          shape: MaterialStateProperty.all(
                            const ContinuousRectangleBorder(),
                          ),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              option = 1;
                              shownpage = OfferingsPageStudent();
                            },
                          );
                        },
                        child: Text(
                          'Projects',
                          style: SafeGoogleFont(
                            'Ubuntu',
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
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              option == 2 ? const Color(0xff302c42) : null),
                          shape: MaterialStateProperty.all(
                            const ContinuousRectangleBorder(),
                          ),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              option = 2;
                              shownpage = const EnrollmentRequestsPage();
                            },
                          );
                        },
                        child: Text(
                          'Enrollment Requests',
                          style: SafeGoogleFont(
                            'Ubuntu',
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
