import 'package:casper/components/projecttile.dart';
import 'package:casper/faculty/loggedinscaffoldFaculty.dart';
import 'package:casper/student/projectPage.dart';
import 'package:casper/utilites.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/text_field.dart';

class EnrollmentsPageFaculty extends StatefulWidget {
  final String role;

  EnrollmentsPageFaculty({Key? key, this.role = 'su'}) : super(key: key);

  @override
  State<EnrollmentsPageFaculty> createState() => _EnrollmentsPageFacultyState();
}

class _EnrollmentsPageFacultyState extends State<EnrollmentsPageFaculty> {
  final semester_controller = TextEditingController(),
      year_controller = TextEditingController(),
      supervisor_name_controller = TextEditingController(),
      project_title_controller = TextEditingController();

  bool? ischecked = false;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Expanded(
      child: Container(
        color: const Color(0xff302c42),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Text(
                    'Enrollments',
                    style: SafeGoogleFont(
                      'Ubuntu',
                      fontSize: 50,
                      fontWeight: FontWeight.w700,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: SizedBox(
                    // height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomTextField(
                                  hinttext: 'Semeseter',
                                  texteditingcontroller: semester_controller,
                                ),
                                CustomTextField(
                                  hinttext: 'Year',
                                  texteditingcontroller: year_controller,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomTextField(
                                  hinttext: 'Supervisor Name',
                                  texteditingcontroller:
                                      supervisor_name_controller,
                                ),
                                CustomTextField(
                                  hinttext: 'Project Title',
                                  texteditingcontroller:
                                      project_title_controller,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[300],
                                  ),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.search,
                                    ),
                                    iconSize: 30,
                                  ),
                                ),
                              ),
                              (widget.role == 'co')
                                  ? SizedBox(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: ischecked,
                                            onChanged: (bool? value) {
                                              setState(
                                                () {
                                                  ischecked = value;
                                                },
                                              );
                                            },
                                            checkColor: Colors.white,
                                            side: const BorderSide(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            'My Enrolments Only',
                                            style: SafeGoogleFont(
                                              'Ubuntu',
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xffffffff),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ProjectTile(
                  info:
                      'Student Name(s) - NAME\nSemester - SEMESTER\nYear - YEAR\nProject Description - DESCRIPTION',
                  title: 'Project Title',
                  title_onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoggedInScaffoldFaculty(
                            role: widget.role,
                            scaffoldbody: Row(
                              children: [
                                ProjectPage(
                                  flag: true,
                                )
                              ],
                            )),
                      ),
                    );
                  },
                  type: 'CP303',
                  theme: 'w',
                  isLink: true,
                ),
                ProjectTile(
                  info:
                      'Student Name(s) - NAME\nSemester - SEMESTER\nYear - YEAR\nProject Description - DESCRIPTION',
                  title: 'Project Title',
                  type: 'CP303',
                  theme: 'w',
                  isLink: true,
                ),
                ProjectTile(
                  info:
                      'Student Name(s) - NAME\nSemester - SEMESTER\nYear - YEAR\nProject Description - DESCRIPTION',
                  title: 'Project Title',
                  type: 'CP303',
                  theme: 'w',
                  isLink: true,
                ),
                ProjectTile(
                  info:
                      'Student Name(s) - NAME\nSemester - SEMESTER\nYear - YEAR\nProject Description - DESCRIPTION',
                  title: 'Project Title',
                  type: 'CP303',
                  theme: 'w',
                  isLink: true,
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
