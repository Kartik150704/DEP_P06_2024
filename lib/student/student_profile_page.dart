import 'package:casper/components/course_tile.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/student/logged_in_scaffold_student.dart';
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
    'Name: Aman Kumar',
    'Program: CSE',
    'CGPA: 8.19',
    'Contact: 1234567890',
  ];
  var courseDetails = [];

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

    return SelectionArea(
      child: LoggedInScaffoldStudent(
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
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(60, 30, 150 * fem, 0),
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
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      width: 550 * fem,
                      margin: const EdgeInsets.fromLTRB(0, 30, 0, 85),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                          ),
                          BoxShadow(
                            color: Color.fromARGB(255, 70, 67, 83),
                            spreadRadius: -3,
                            blurRadius: 7,
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              CourseTile(
                                code: 'CP301',
                                status: '2',
                                details: const [
                                  'A-',
                                  '2',
                                  '2022',
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CourseTile(
                                code: 'CP302',
                                status: '1',
                                details: const [
                                  'NA',
                                  '1',
                                  '2023',
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CourseTile(
                                code: 'CP302',
                                status: '1',
                                details: const [
                                  'NA',
                                  '1',
                                  '2023',
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
