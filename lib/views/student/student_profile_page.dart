import 'package:casper/components/course_tile.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/scaffolds/student_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/confirm_action.dart';

class StudentProfilePage extends StatefulWidget {
  final uid;
  const StudentProfilePage({
    Key? key,
    this.uid,
  }) : super(key: key);

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  var student = ['', '', '', '', '', ''];
  var team = ['', ''];
  var canJoinNewTeam = false;
  var studentDetails = [
    'Name: Aman Kumar',
    'Program: CSE',
    'CGPA: 8.19',
    'Contact: 1234567890',
  ];
  var courseDetails = [
    [
      'CP301',
      '2',
      ['A-', '2', '2022']
    ],
    [
      'CP302',
      '1',
      ['NA', '1', '2023']
    ],
    [
      'CP303',
      '0',
      ['NA', 'NA', 'NA']
    ],
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

  void fetchName() {
    setState(() {
      student = ['', '', '', '', '', ''];
      team = ['', ''];
    });
    FirebaseFirestore.instance.collection('student').get().then((value) {
      value.docs.forEach((element) {
        var doc = element.data();
        if (doc['uid'] == widget.uid && widget.uid != null) {
          setState(() {
            student[0] = (doc['name']);
            student[1] = (doc['department']);
            student[2] = (doc['id']);
            student[3] = (doc['cgpa']);
            student[4] = (doc['contact']);
            student[5] = (doc['proj_id'][0]);

            FirebaseFirestore.instance
                .collection('projects')
                .doc(student[5])
                .get()
                .then((value) {
              var doc = value.data();
              setState(() {
                team[0] = doc!['student_name'][0];
                team[1] = doc['student_name'][1];
              });
            });
          });
        }
      });
    });
  }

  void joinNewTeam() {}

  @override
  void initState() {
    super.initState();
    fetchName();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = (MediaQuery.of(context).size.width / baseWidth) * 0.97;

    return SelectionArea(
      child: StudentScaffold(
        uid: widget.uid,
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
                      ] else ...[
                        CustomisedText(text: 'Team ID - ${student[5]}'),
                        SizedBox(
                          height: 15,
                        ),
                        CustomisedText(text: 'Team Members'),
                        SizedBox(
                          height: 4,
                        ),
                        CustomisedText(
                          text: '${team[0]}\n${team[1]}',
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
                      margin: EdgeInsets.fromLTRB(60, 30, 200 * fem, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomisedText(
                            text: student[0].split(' ')[0] + '\'s Profile',
                            fontSize: 50,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          for (int i = 0; i < student.length; i++) ...[
                            if (i == 0)
                              Container(
                                margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: CustomisedText(
                                  text: 'Name: ${student[i]}',
                                  fontSize: 25,
                                ),
                              ),
                            if (i == 1)
                              Container(
                                margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: CustomisedText(
                                  text: 'Program: ${student[i]}',
                                  fontSize: 25,
                                ),
                              ),
                            if (i == 2)
                              Container(
                                margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: CustomisedText(
                                  text: 'Entry No: ${student[i]}',
                                  fontSize: 25,
                                ),
                              ),
                            if (i == 3)
                              Container(
                                margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: CustomisedText(
                                  text: 'Cgpa: ${student[i]}',
                                  fontSize: 25,
                                ),
                              ),
                            if (i == 4)
                              Container(
                                margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: CustomisedText(
                                  text: 'Contact: ${student[i]}',
                                  fontSize: 25,
                                ),
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      width: 500 * fem,
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
                              for (int i = 0;
                                  i < courseDetails.length;
                                  i++) ...[
                                CourseTile(
                                  code: courseDetails[i][0],
                                  status: courseDetails[i][1],
                                  details: courseDetails[i][2],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
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
