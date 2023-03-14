import 'package:casper/faculty/enrollmentRequestsFaculty.dart';
import 'package:casper/faculty/loggedinscaffoldFaculty.dart';
import 'package:casper/faculty/offeringsPageFaculty.dart';
import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';

class FacultyOfferings extends StatefulWidget {
  const FacultyOfferings({Key? key}) : super(key: key);

  @override
  State<FacultyOfferings> createState() => _FacultyOfferingsState();
}

class _FacultyOfferingsState extends State<FacultyOfferings> {
  void onPressed() {}
  dynamic shownpage;
  var option;

  @override
  void initState() {
    super.initState();
    option = 1;
    shownpage = OfferingsPageFaculty();
  }

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
                              shownpage = OfferingsPageFaculty();
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
                              shownpage = EnrollmentRequestsPageFaculty();
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
