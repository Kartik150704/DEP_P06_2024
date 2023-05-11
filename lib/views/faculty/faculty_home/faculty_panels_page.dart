import 'dart:math';

import 'package:casper/data_tables/faculty/faculty_panels_data_table.dart';
import 'package:casper/comp/customised_text.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/models/models.dart';
import 'package:casper/models/seeds.dart';
import 'package:casper/views/shared/loading_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FacultyPanelsPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final userRole, viewPanel;

  const FacultyPanelsPage({
    Key? key,
    required this.userRole,
    required this.viewPanel,
  }) : super(key: key);

  @override
  State<FacultyPanelsPage> createState() => _FacultyPanelsPageState();
}

class _FacultyPanelsPageState extends State<FacultyPanelsPage> {
  bool loading = true, searching = false;
  late List<AssignedPanel> assignedPanels = [];
  final panelIdController = TextEditingController(),
      evaluatorNameController = TextEditingController(),
      termController = TextEditingController(),
      courseController = TextEditingController(text: 'CP302'),
      yearSemesterController = TextEditingController(text: '2023-1');
  final horizontalScrollController = ScrollController(),
      verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('instructors')
        .where(
          'uid',
          isEqualTo: FirebaseAuth.instance.currentUser?.uid,
        )
        .get()
        .then(
      (value) {
        var doc = value.docs[0];
        List<String> panelids = List<String>.from(
          doc['panel_ids'],
        );
        print(FirebaseAuth.instance.currentUser?.uid);
        if (panelids.isEmpty) {
          setState(() {
            loading = false;
            searching = false;
          });

          return;
        }
        FirebaseFirestore.instance
            .collection('assigned_panel')
            .where('panel_id', whereIn: panelids)
            .get()
            .then(
          (value) {
            for (var doc in value.docs) {
              setState(() {
                assignedPanels.add(
                  AssignedPanel(
                    id: doc['panel_id'],
                    course: doc['course'],
                    term: doc['term'],
                    semester: doc['semester'],
                    year: doc['year'],
                    numberOfAssignedTeams: 1,
                    panel: Panel(
                      course: doc['course'],
                      semester: doc['semester'],
                      year: doc['year'],
                      id: doc['panel_id'],
                      numberOfEvaluators: int.parse(
                        doc['number_of_evaluators'],
                      ),
                      evaluators: List<Faculty>.generate(
                        int.parse(
                          doc['number_of_evaluators'],
                        ),
                        (index) => Faculty(
                            id: doc['evaluator_ids'][index],
                            name: doc['evaluator_names'][index],
                            email: ''),
                      ),
                    ),
                    assignedTeams: [],
                    evaluations: [evaluationsGLOBAL[4]],
                    assignedProjectIds: List<String>.from(
                      doc['assigned_project_ids'],
                    ),
                    numberOfAssignedProjects: int.tryParse(
                      doc['number_of_assigned_projects'],
                    ),
                  ),
                );
              });
              setState(() {
                loading = false;
                searching = false;
              });
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double wfem = (MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio) /
        baseWidth;
    double hfem = (MediaQuery.of(context).size.height *
            MediaQuery.of(context).devicePixelRatio) /
        baseWidth;

    if (loading) {
      return const LoadingPage();
    }

    return Expanded(
      child: Container(
        color: const Color(0xff302c42),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(60, 30, 0, 0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomisedText(
                        text: 'My Panels',
                        fontSize: 50,
                      ),
                      Container(),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 33 * wfem,
                      ),
                      Tooltip(
                        message: 'Panel Identification Number',
                        child: SearchTextField(
                          textEditingController: panelIdController,
                          hintText: 'Panel Identification',
                          width: 170 * wfem,
                        ),
                      ),
                      SizedBox(
                        width: 20 * wfem,
                      ),
                      Tooltip(
                        message: 'Evaluator\'s Name',
                        child: SearchTextField(
                          textEditingController: evaluatorNameController,
                          hintText: 'Evaluator\'s Name',
                          width: 170 * wfem,
                        ),
                      ),
                      SizedBox(
                        width: 20 * wfem,
                      ),
                      Tooltip(
                        message: 'Term Type',
                        child: SearchTextField(
                          textEditingController: termController,
                          hintText: 'Term',
                          width: 170 * wfem,
                        ),
                      ),
                      SizedBox(
                        width: 20 * wfem,
                      ),
                      Tooltip(
                        message: 'Course Code',
                        child: SearchTextField(
                          textEditingController: courseController,
                          hintText: 'Course',
                          width: 170 * wfem,
                        ),
                      ),
                      SizedBox(
                        width: 20 * wfem,
                      ),
                      Tooltip(
                        message: 'Session (Year-Semester)',
                        child: SearchTextField(
                          textEditingController: yearSemesterController,
                          hintText: 'Session',
                          width: 170 * wfem,
                        ),
                      ),
                      SizedBox(
                        width: 25 * wfem,
                      ),
                      SizedBox(
                        height: 47,
                        width: 47,
                        child: FloatingActionButton(
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 212, 203, 216),
                          splashColor: Colors.black,
                          hoverColor: Colors.grey,
                          child: const Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 29,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1200 * wfem,
                    height: 1000 * hfem,
                    margin: EdgeInsets.fromLTRB(40, 15, 80 * wfem, 0),
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
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      // TODO: Implement search
                      child: (searching
                          ? SizedBox(
                              width: double.infinity,
                              height: 500 * wfem,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 500,
                              width: 400,
                              child: Scrollbar(
                                controller: verticalScrollController,
                                thumbVisibility: true,
                                trackVisibility: true,
                                child: Scrollbar(
                                  controller: horizontalScrollController,
                                  thumbVisibility: true,
                                  trackVisibility: true,
                                  notificationPredicate: (notif) =>
                                      notif.depth == 1,
                                  child: SingleChildScrollView(
                                    controller: verticalScrollController,
                                    child: SingleChildScrollView(
                                      controller: horizontalScrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: SizedBox(
                                        width: max(1217, 950 * wfem),
                                        child: FacultyPanelsDataTable(
                                          userRole: widget.userRole,
                                          viewPanel: widget.viewPanel,
                                          assignedPanels: assignedPanels,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                    ),
                  ),
                  const SizedBox(
                    height: 65,
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
