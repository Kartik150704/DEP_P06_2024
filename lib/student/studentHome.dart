import 'package:casper/components/textstyle.dart';
import 'package:casper/student/loggedinscaffoldStudent.dart';
import 'package:casper/student/projectPage.dart';
import 'package:casper/utils.dart';
import 'package:flutter/material.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  void onPressed() {}
  var option;

  @override
  void initState() {
    super.initState();
    option = 1;
  }

  ProjectPage projectpage = ProjectPage(
    flag: true,
  );

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
                              option == 2 ? const Color(0xff302c42) : null),
                          shape: MaterialStateProperty.all(
                            const ContinuousRectangleBorder(),
                          ),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              option = 2;
                              projectpage = ProjectPage(
                                flag: false,
                              );
                            },
                          );
                        },
                        child: Text(
                          'CP302',
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
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              option == 3 ? const Color(0xff302c42) : null),
                          shape: MaterialStateProperty.all(
                            const ContinuousRectangleBorder(),
                          ),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              option = 3;
                              projectpage = ProjectPage(
                                flag: false,
                              );
                            },
                          );
                        },
                        child: Text(
                          'CP303',
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
          projectpage,
        ],
      ),
    );
  }
}
