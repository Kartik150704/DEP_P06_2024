import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/student/logged_in_scaffold_student.dart';
import 'package:casper/student/projectPage.dart';
import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/confirm_action.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({Key? key}) : super(key: key);

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  var canJoinNewTeam = false;
  var studentDetails = [
    'Name: Ojassvi Kumar',
    'Program: CSE',
    'CGPA: 8.19',
    'Contact: 9250131555',
  ];

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

  void joinNewTeam() {}

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = (MediaQuery.of(context).size.width / baseWidth) * 0.97;

    return LoggedInScaffoldStudent(
      studentScaffoldBody: Row(
        children: [
          Container(
            width: 300 * fem,
            color: const Color(0xff545161),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg',
                            ),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                    if (canJoinNewTeam) ...[
                      CustomisedButton(
                        width: 200,
                        height: 50,
                        text: 'Join A New Team',
                        onPressed: joinNewTeam,
                      )
                    ] else ...const [
                      CustomisedText(text: 'Team ID - CS48'),
                      SizedBox(
                        height: 15,
                      ),
                      CustomisedText(text: 'Team Members'),
                      SizedBox(
                        height: 4,
                      ),
                      CustomisedText(
                        text: 'Ojassvi Kumar\nAman Kumar',
                        fontSize: 17,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              color: const Color(0xff302c42),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(40, 25, 400, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomisedText(
                          text: 'Ojassvi\'s Profile',
                          fontSize: 50,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        for (int i = 0; i < studentDetails.length; i++) ...[
                          Container(
                            margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: CustomisedText(
                              text: studentDetails[i],
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                        width: 400 * fem,
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
                                    'Ubuntu',
                                    fontSize: 35 * fem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2175 * fem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'CP301 ',
                                    ),
                                    TextSpan(
                                      text: '(Completed)',
                                      style: SafeGoogleFont(
                                        'Ubuntu',
                                        fontSize: 25 * fem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2175 * fem / fem,
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
                                  'Ubuntu',
                                  fontSize: 25 * fem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2175 * fem / fem,
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
                                  'Ubuntu',
                                  fontSize: 25 * fem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2175 * fem / fem,
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
                                  'Ubuntu',
                                  fontSize: 25 * fem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2175 * fem / fem,
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
                                    'Ubuntu',
                                    fontSize: 35 * fem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2175 * fem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'CP302 ',
                                    ),
                                    TextSpan(
                                      text: '(Ongoing)',
                                      style: SafeGoogleFont(
                                        'Ubuntu',
                                        fontSize: 25 * fem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2175 * fem / fem,
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
                                  'Ubuntu',
                                  fontSize: 25 * fem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2175 * fem / fem,
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
                                  'Ubuntu',
                                  fontSize: 25 * fem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2175 * fem / fem,
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
                                  'Ubuntu',
                                  fontSize: 25 * fem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2175 * fem / fem,
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
