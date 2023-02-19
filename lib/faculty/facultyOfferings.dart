import 'package:casper/faculty/enrollmentRequestsFaculty.dart';
import 'package:casper/faculty/loggedinscaffoldFaculty.dart';
import 'package:casper/faculty/offeringsPageFaculty.dart';
import 'package:casper/utils.dart';
import 'package:flutter/material.dart';

class FacultyOfferings extends StatefulWidget {
  const FacultyOfferings({Key? key}) : super(key: key);

  @override
  State<FacultyOfferings> createState() => _FacultyOfferingsState();
}

class _FacultyOfferingsState extends State<FacultyOfferings> {
  void onPressed() {}
  dynamic shownpage = OfferingsPageFaculty();

  @override
  Widget build(BuildContext context) {
    return LoggedInScaffoldFaculty(
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
                              shownpage = OfferingsPageFaculty();
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
                              shownpage = EnrollmentRequestsPageFaculty();
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
