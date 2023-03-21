import 'package:casper/components/customised_text.dart';
import 'package:casper/components/evaluation_tile.dart';
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
                          margin: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              for (int i = 0;
                                  i < evaluationDetails.length;
                                  i++) ...[
                                EvaluationTile(
                                  status: evaluationDetails[i][0],
                                  week: evaluationDetails[i][1],
                                  details: evaluationDetails[i][2],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ],
                          ),
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
