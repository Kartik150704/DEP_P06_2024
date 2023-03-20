import 'package:casper/faculty/loggedinscaffoldFaculty.dart';
import 'package:casper/student/logged_in_scaffold_student.dart';
import 'package:casper/student/projectPage.dart';
import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';

class FacultyProfile extends StatefulWidget {
  final role;

  const FacultyProfile({Key? key, required this.role}) : super(key: key);

  @override
  State<FacultyProfile> createState() => _FacultyProfileState();
}

class _FacultyProfileState extends State<FacultyProfile> {
  void onPressed() {}

  ProjectPage projectpage = ProjectPage(
    flag: true,
  );

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return LoggedInScaffoldFaculty(
      role: widget.role,
      scaffoldbody: Row(
        children: [
          Container(
            width: 300,
            color: const Color(0xff545161),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: 200.0,
                        width: 120.0,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg'),
                            fit: BoxFit.fitHeight,
                          ),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Center(
                        child: Text(
                          'Faculty ID -',
                          style: SafeGoogleFont(
                            'Ubuntu',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding:
                  EdgeInsets.fromLTRB(34 * fem, 40 * fem, 0 * fem, 40 * fem),
              height: double.infinity,
              color: const Color(0xff302c42),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 289 * fem, 0 * fem),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              66 * fem, 0 * fem, 0 * fem, 70 * fem),
                          child: Text(
                            'Profile',
                            style: SafeGoogleFont(
                              'Ubuntu',
                              fontSize: 50 * ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.2175 * ffem / fem,
                              color: const Color(0xffffffff),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 0 * fem, 9 * fem),
                          child: Text(
                            'Name - NAME',
                            style: SafeGoogleFont(
                              'Ubuntu',
                              fontSize: 25 * ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.2175 * ffem / fem,
                              color: const Color(0xffffffff),
                            ),
                          ),
                        ),
                        Container(
                          // programprogram5jG (225:254)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 0 * fem, 9 * fem),
                          child: Text(
                            'Department - DEPARTMENT',
                            style: SafeGoogleFont(
                              'Ubuntu',
                              fontSize: 25 * ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.2175 * ffem / fem,
                              color: const Color(0xffffffff),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 0 * fem, 9 * fem),
                          child: Text(
                            'Contact - CONTACT',
                            style: SafeGoogleFont(
                              'Ubuntu',
                              fontSize: 25 * ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.2175 * ffem / fem,
                              color: const Color(0xffffffff),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
