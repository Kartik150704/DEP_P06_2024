import 'package:casper/student/no_projects_found_page.dart';
import 'package:casper/utilites.dart';
import 'package:casper/components/weektile.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/marks_submission_form.dart';

class ProjectPage extends StatefulWidget {
  final project;
  final flag;

  const ProjectPage({
    Key? key,
    this.flag = true,
    required this.project,
  }) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  TextEditingController weeklyMarksInputController = TextEditingController();
  TextEditingController weeklyMarksConfirmInputController =
      TextEditingController();

  void uploadWeeklyMarks() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: MarksSubmissionForm(
            marksInputController: weeklyMarksInputController,
            marksConfirmInputController: weeklyMarksConfirmInputController,
            onSubmit: () {},
          )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = (MediaQuery.of(context).size.width / baseWidth) * 0.97;

    if (widget.project == null) {
      return const NoProjectsFoundPage();
    } else {}

    if (widget.flag) {
      return Expanded(
        child: Container(
          color: const Color(0xff302c42),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: Text(
                      'Fair Clustering Algorithms',
                      style: SafeGoogleFont(
                        'Ubuntu',
                        fontSize: 50,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        child: Text(
                          'Dr Shweta Jain - 2023 II',
                          style: SafeGoogleFont(
                            'Ubuntu',
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 5),
                            child: Text(
                              'Aman Kumar',
                              style: SafeGoogleFont(
                                'Ubuntu',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 5),
                            child: Text(
                              'Ojassvi Kumar',
                              style: SafeGoogleFont(
                                'Ubuntu',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  WeekTile(
                    datefrom: '03/01/2023',
                    dateto: '09/01/2023',
                    weekname: 'Week 1',
                    remarks: 'Good!',
                    marksobtained: 'Marks Not Uploaded Yet',
                    flag: false,
                    buttonflag: true,
                    buttonOnPressed: uploadWeeklyMarks,
                    buttontext: 'Add Marks',
                  ),
                  const WeekTile(
                    datefrom: '03/01/2023',
                    dateto: '09/01/2023',
                    weekname: 'Week 2',
                    remarks: 'Good!',
                    marksobtained: '97/100',
                    flag: true,
                  )
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return Expanded(
        child: Container(
          color: Color(0xff302c42),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                'No project found!',
                style: SafeGoogleFont(
                  'Ubuntu',
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffffffff),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
