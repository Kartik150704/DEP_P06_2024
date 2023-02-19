import 'package:casper/student/loggedinscaffoldStudent.dart';
import 'package:casper/student/projectPage.dart';
import 'package:casper/utils.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/confirm_action.dart';

class studentProfile extends StatefulWidget {
  const studentProfile({Key? key}) : super(key: key);

  @override
  State<studentProfile> createState() => _studentProfileState();
}

class _studentProfileState extends State<studentProfile> {
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

  ProjectPage projectpage = ProjectPage(
    flag: true,
  );

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return LoggedInScaffoldStudent(
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
                          'TEAM ID - TEAM ID',
                          style: SafeGoogleFont(
                            'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Center(
                        child: Text(
                          'Team Members -',
                          style: SafeGoogleFont(
                            'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'NAME-1',
                            style: SafeGoogleFont(
                              'Montserrat',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'NAME-2',
                            style: SafeGoogleFont(
                              'Montserrat',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      // margin: EdgeInsets.fromLTRB(20, 5, 40, 0),
                      width: 50,
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xff6f6f6f),
                                  borderRadius: BorderRadius.circular(8)),
                              height: 40,
                              child: TextButton(
                                onPressed: null,
                                child: Center(
                                  child: Text(
                                    'Join A Team',
                                    style: SafeGoogleFont(
                                      'Montserrat',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xffb0b0b0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xff1a1e2e),
                                  borderRadius: BorderRadius.circular(8)),
                              height: 40,
                              child: TextButton(
                                onPressed: confirmAction,
                                child: Center(
                                  child: Text(
                                    'Leave Team',
                                    style: SafeGoogleFont(
                                      'Montserrat',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xffffffff),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
                              'Montserrat',
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
                              'Montserrat',
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
                            'Program - PROGRAM',
                            style: SafeGoogleFont(
                              'Montserrat',
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
                              'Montserrat',
                              fontSize: 25 * ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.2175 * ffem / fem,
                              color: const Color(0xffffffff),
                            ),
                          ),
                        ),
                        Text(
                          'CGPA - CGPA',
                          style: SafeGoogleFont(
                            'Montserrat',
                            fontSize: 25 * ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.2175 * ffem / fem,
                            color: const Color(0xffffffff),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // frame66q6A (225:257)
                        margin: EdgeInsets.fromLTRB(
                            3 * fem, 0 * fem, 0 * fem, 25 * fem),
                        padding: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 0 * fem, 51 * fem),
                        width: 450 * fem,
                        decoration: BoxDecoration(
                          color: const Color(0xff45c646),
                          borderRadius: BorderRadius.circular(10 * fem),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x3f000000),
                              offset: Offset(0 * fem, 4 * fem),
                              blurRadius: 2 * fem,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // frame68K1L (225:259)
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 0 * fem, 16 * fem),
                              padding: EdgeInsets.fromLTRB(
                                  59 * fem, 12 * fem, 59 * fem, 17 * fem),
                              width: 953 * fem,
                              decoration: BoxDecoration(
                                color: const Color(0xff7ae37b),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10 * fem),
                                  topRight: Radius.circular(10 * fem),
                                ),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: SafeGoogleFont(
                                    'Montserrat',
                                    fontSize: 35 * ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2175 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'CP301 ',
                                    ),
                                    TextSpan(
                                      text: '(Completed)',
                                      style: SafeGoogleFont(
                                        'Montserrat',
                                        fontSize: 25 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2175 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  20 * fem, 0 * fem, 0 * fem, 8 * fem),
                              child: Text(
                                'Grade - GRADE',
                                style: SafeGoogleFont(
                                  'Montserrat',
                                  fontSize: 25 * ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2175 * ffem / fem,
                                  color: const Color(0xff3f3f3f),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  20 * fem, 0 * fem, 0 * fem, 8 * fem),
                              child: Text(
                                'Semester - SEMESTER',
                                style: SafeGoogleFont(
                                  'Montserrat',
                                  fontSize: 25 * ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2175 * ffem / fem,
                                  color: const Color(0xff3f3f3f),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  20 * fem, 0 * fem, 0 * fem, 0 * fem),
                              child: Text(
                                'Year - YEAR',
                                style: SafeGoogleFont(
                                  'Montserrat',
                                  fontSize: 25 * ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2175 * ffem / fem,
                                  color: const Color(0xff3f3f3f),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 3 * fem, 0 * fem),
                        padding: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 0 * fem, 51 * fem),
                        width: 450 * fem,
                        decoration: BoxDecoration(
                          color: const Color(0xfffabb18),
                          borderRadius: BorderRadius.circular(10 * fem),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x3f000000),
                              offset: Offset(0 * fem, 4 * fem),
                              blurRadius: 2 * fem,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 0 * fem, 16 * fem),
                              padding: EdgeInsets.fromLTRB(
                                  59 * fem, 12 * fem, 59 * fem, 17 * fem),
                              width: 953 * fem,
                              decoration: BoxDecoration(
                                color: const Color(0xffe0c596),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10 * fem),
                                  topRight: Radius.circular(10 * fem),
                                ),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: SafeGoogleFont(
                                    'Montserrat',
                                    fontSize: 35 * ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2175 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'CP302 ',
                                    ),
                                    TextSpan(
                                      text: '(Ongoing)',
                                      style: SafeGoogleFont(
                                        'Montserrat',
                                        fontSize: 25 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2175 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  20 * fem, 0 * fem, 0 * fem, 8 * fem),
                              child: Text(
                                'Grade - NA',
                                style: SafeGoogleFont(
                                  'Montserrat',
                                  fontSize: 25 * ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2175 * ffem / fem,
                                  color: const Color(0xff3f3f3f),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  20 * fem, 0 * fem, 0 * fem, 8 * fem),
                              child: Text(
                                'Semester - SEMESTER',
                                style: SafeGoogleFont(
                                  'Montserrat',
                                  fontSize: 25 * ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2175 * ffem / fem,
                                  color: const Color(0xff3f3f3f),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  20 * fem, 0 * fem, 0 * fem, 0 * fem),
                              child: Text(
                                'Year - YEAR',
                                style: SafeGoogleFont(
                                  'Montserrat',
                                  fontSize: 25 * ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2175 * ffem / fem,
                                  color: const Color(0xff3f3f3f),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
