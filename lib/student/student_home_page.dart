import 'package:casper/components/textstyle.dart';
import 'package:casper/student/logged_in_scaffold_student.dart';
import 'package:casper/student/projectPage.dart';
import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  // ignore: prefer_typing_uninitialized_variables
  var selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = 1;
  }

  void onPressed() {}

  ProjectPage projectpage = ProjectPage(
    flag: true,
  );

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: LoggedInScaffoldStudent(
        studentScaffoldBody: Row(
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
                                selectedOption == 1
                                    ? const Color(0xff302c42)
                                    : null),
                            shape: MaterialStateProperty.all(
                              const ContinuousRectangleBorder(),
                            ),
                          ),
                          onPressed: () {
                            setState(
                              () {
                                selectedOption = 1;
                                projectpage = ProjectPage(
                                  flag: true,
                                );
                              },
                            );
                          },
                          child: Text(
                            'CP301',
                            style: CustomTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                selectedOption == 2
                                    ? const Color(0xff302c42)
                                    : null),
                            shape: MaterialStateProperty.all(
                              const ContinuousRectangleBorder(),
                            ),
                          ),
                          onPressed: () {
                            setState(
                              () {
                                selectedOption = 2;
                                projectpage = ProjectPage(
                                  flag: false,
                                );
                              },
                            );
                          },
                          child: Text(
                            'CP302',
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
                                selectedOption == 3
                                    ? const Color(0xff302c42)
                                    : null),
                            shape: MaterialStateProperty.all(
                              const ContinuousRectangleBorder(),
                            ),
                          ),
                          onPressed: () {
                            setState(
                              () {
                                selectedOption = 3;
                                projectpage = ProjectPage(
                                  flag: false,
                                );
                              },
                            );
                          },
                          child: Text(
                            'CP303',
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
            projectpage,
          ],
        ),
      ),
    );
  }
}
