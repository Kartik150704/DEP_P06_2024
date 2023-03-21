import 'package:casper/components/customised_text.dart';
import 'package:casper/student/no_projects_found_page.dart';
import 'package:casper/components/weektile.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/marks_submission_form.dart';

class ProjectPage extends StatefulWidget {
  final project;

  const ProjectPage({
    Key? key,
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
    } else {
      return Expanded(
        child: Container(
          color: const Color(0xff302c42),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(60, 30, 200 * fem, 0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomisedText(
                      text: widget.project[0],
                      fontSize: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: CustomisedText(
                            text: widget.project[1] +
                                ' - ' +
                                widget.project[2] +
                                ' ' +
                                widget.project[3],
                            fontSize: 25,
                          ),
                        ),
                        Column(
                          children: const [
                            SizedBox(
                              height: 30,
                            ),
                            CustomisedText(
                              text: 'Ojassvi Kumar',
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
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
