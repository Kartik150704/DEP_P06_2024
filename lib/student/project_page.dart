import 'package:casper/components/customised_button.dart';
import 'package:casper/components/evaluation_data_table.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/student/no_projects_found_page.dart';
import 'package:flutter/material.dart';

class ProjectPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final project;

  const ProjectPage({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  var evaluationDetails = [
    [
      '1',
      'Week 4',
      ['NA', 'NA'],
    ],
    [
      '1',
      'Week 3',
      ['NA', 'NA'],
    ],
    [
      '2',
      'Week 2',
      ['97/100', 'Good work'],
    ],
    [
      '2',
      'Week 1',
      ['97/100', 'Good work'],
    ],
  ];

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
                margin: EdgeInsets.fromLTRB(60, 30, 100 * fem, 0),
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
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomisedText(
                              text: widget.project[4][0],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomisedText(
                              text: widget.project[4][1],
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 670,
                      width: 1200 * fem,
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 75),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 70, 67, 83),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            spreadRadius: 3,
                            blurRadius: 20,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      // ignore: prefer_const_constructors
                      child: SingleChildScrollView(
                        // ignore: prefer_const_constructors
                        child: EvaluationDataTable(
                          // ignore: prefer_const_literals_to_create_immutables
                          evaluations: <Evaluation>[
                            const Evaluation(
                              week: 'Week 5',
                              date: '05/04 - 12/04',
                              marks: 'NA',
                              remarks: 'NA',
                              status: '0',
                            ),
                            const Evaluation(
                              week: 'Week 4',
                              date: '29/03 - 05/04',
                              marks: 'NA',
                              remarks: 'NA',
                              status: '1',
                            ),
                            const Evaluation(
                              week: 'Week 3',
                              date: '22/03 - 29/03',
                              marks: 'NA',
                              remarks: 'NA',
                              status: '1',
                            ),
                            const Evaluation(
                              week: 'Week 2',
                              date: '15/03 - 22/03',
                              marks: '19/20',
                              remarks:
                                  'Good work aabafg asdfasd asdfasd a asdfas asdfas',
                              status: '2',
                            ),
                            const Evaluation(
                              week: 'Week 1',
                              date: '09/03 - 15/03',
                              marks: '19/20',
                              remarks: 'Good work good work good work goooood',
                              status: '2',
                            ),
                          ],
                        ),
                      ),
                    ),
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

class Evaluation {
  final String week, date, marks, remarks, status;

  const Evaluation({
    required this.week,
    required this.date,
    required this.marks,
    required this.remarks,
    required this.status,
  });
}
