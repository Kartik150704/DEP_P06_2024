import 'dart:math';

import 'package:casper/components/form_custom_text.dart';
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
  late final cachedAssignedPanels;
  String? panelID, evaluatorName, term, course, yearSemester;

  Map panelEvalutaions = {};
  Map assignedTeams = {};

  bool loading_teams_and_evaluations = true;

  void updateEvaluation(Evaluation newEvaluation, String panelId) {
    List<Evaluation> evaluations = panelEvalutaions[panelId];
    for (int i = 0; i < evaluations.length; i++) {
      if (evaluations[i].student.id == newEvaluation.student.id) {
        evaluations[i] = newEvaluation;
        break;
      }
    }
    setState(() {
      panelEvalutaions[panelId] = evaluations;
    });
    print('updated evaluation');
  }

  void getAssignedPanels() async {
    await FirebaseFirestore.instance
        .collection('instructors')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then(
      (value) async {
        var doc = value.docs[0];
        List<String> panelids = List<String>.from(
          doc['panel_ids'],
        );
        if (panelids.isEmpty) {
          setState(() {
            loading = false;
            searching = false;
          });
          return;
        }
        await FirebaseFirestore.instance
            .collection('assigned_panel')
            .where('panel_id', whereIn: panelids)
            .get()
            .then(
          (value) async {
            for (var doc in value.docs) {
              setState(() {
                assignedPanels.add(
                  AssignedPanel(
                    id: doc['panel_id'],
                    course: doc['course'],
                    term: doc['term'],
                    semester: doc['semester'],
                    year: doc['year'],
                    numberOfAssignedTeams:
                        int.parse(doc['number_of_assigned_projects']),
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
                    assignedTeams: assignedTeams[doc['panel_id']] ?? [],
                    evaluations: panelEvalutaions[doc['panel_id']] ?? [],
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
    setState(() {
      cachedAssignedPanels = assignedPanels;
    });
  }

  void getEvaluations() async {
    List<String> teams = [];
    List<String> panelIds = [];
    int localIndexEvaluations = 0;
    await FirebaseFirestore.instance
        .collection('instructors')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((instructorValue) {
      for (var doc in instructorValue.docs) {
        panelIds = doc['panel_ids'].cast<String>();
      }
    });
    if (panelIds.isEmpty) {
      setState(() {
        loading = false;
        searching = false;
        loading_teams_and_evaluations = false;
      });
      return;
    }

    await FirebaseFirestore.instance
        .collection('assigned_panel')
        .where('panel_id', whereIn: panelIds)
        .get()
        .then((assignedPanelValue) async {
      for (var doc in assignedPanelValue.docs) {
        List<String> releasedEvents = [];
        List<Evaluation> evaluations = [];
        List<Faculty> facultyInPanel = [];
        String panelType = doc['term'];
        String panel_id = doc['panel_id'];
        for (int i = 0; i < doc['evaluator_ids'].length; i++) {
          Faculty faculty = Faculty(
            id: doc['evaluator_ids'][i],
            name: doc['evaluator_names'][i],
            //TODO: never used so passsing placeholder
            email: 'placeholder',
          );
          facultyInPanel.add(faculty);
        }

        if (doc['assigned_project_ids'].isEmpty) continue;

        await FirebaseFirestore.instance
            .collection('released_events')
            .where('semester', isEqualTo: doc['semester'])
            .where('year', isEqualTo: doc['year'])
            .where('course', isEqualTo: doc['course'])
            .get()
            .then((releasedEventsValue) async {
          if (releasedEventsValue.docs.length == 1) {
            releasedEvents =
                releasedEventsValue.docs[0]['events'].keys.toList();
          }
        });
        // print(releasedEvents);
        await FirebaseFirestore.instance
            .collection('evaluations')
            .where('project_id', whereIn: doc['assigned_project_ids'])
            .get()
            .then((evaluationValue) async {
          for (var doc in evaluationValue.docs) {
            // for loop faculty
            // for loop student
            List<Student> studentInProject = [];
            late String teamid;
            for (int i = 0; i < doc['student_ids'].length; i++) {
              Student student = Student(
                id: doc['student_ids'][i],
                name: doc['student_names'][i],
                entryNumber: doc['student_ids'][i],
                email: '${doc['student_ids'][i]}@iitrpr.ac.in',
              );
              studentInProject.add(student);
            }

            await FirebaseFirestore.instance
                .collection('projects')
                .where(FieldPath.documentId, isEqualTo: doc['project_id'])
                .get()
                .then((projectValue) async {
              if (projectValue.docs.length == 1) {
                teamid = projectValue.docs[0]['team_id'];
              }
            });
            Team team = Team(
                id: teamid,
                numberOfMembers: studentInProject.length,
                students: studentInProject);
            setState(() {
              if (assignedTeams.containsKey(panel_id)) {
                assignedTeams[panel_id].add(team);
              } else {
                assignedTeams[panel_id] = [team];
              }
            });
            // print('project id: ${doc['project_id']}');
            for (int i = 0; i < facultyInPanel.length; i++) {
              for (int j = 0; j < studentInProject.length; j++) {
                Evaluation? mid, end;
                if ((panelType == 'MidTerm' || panelType == 'All') &&
                    releasedEvents.contains('MidTerm')) {
                  if (doc['midsem_evaluation'][i]
                          [studentInProject[j].entryNumber] !=
                      null) {
                    mid = Evaluation(
                      id: doc.id,
                      marks: double.parse(doc['midsem_evaluation'][i]
                          [studentInProject[j].entryNumber]),
                      remarks: doc['midsem_panel_comments'][i]
                              [studentInProject[j].entryNumber] ??
                          'NA',
                      type: 'MidTerm',
                      student: studentInProject[j],
                      faculty: facultyInPanel[i],
                      panelIndex: i,
                      done: true,
                      localIndex: localIndexEvaluations++,
                    );
                  } else {
                    mid = Evaluation(
                      id: doc.id,
                      marks: -1.0,
                      remarks: doc['midsem_panel_comments'][i]
                              [studentInProject[j].entryNumber] ??
                          'NA',
                      type: 'MidTerm',
                      student: studentInProject[j],
                      faculty: facultyInPanel[i],
                      panelIndex: i,
                      done: false,
                      localIndex: localIndexEvaluations++,
                    );
                  }
                }
                if ((panelType == 'EndTerm' || panelType == 'All') &&
                    releasedEvents.contains('EndTerm')) {
                  if (doc['endsem_evaluation'][i]
                          [studentInProject[j].entryNumber] !=
                      null) {
                    end = Evaluation(
                      id: doc.id,
                      marks: double.parse(doc['endsem_evaluation'][i]
                          [studentInProject[j].entryNumber]),
                      remarks: doc['endsem_panel_comments'][i]
                              [studentInProject[j].entryNumber] ??
                          'NA',
                      type: 'EndTerm',
                      student: studentInProject[j],
                      faculty: facultyInPanel[i],
                      panelIndex: i,
                      done: true,
                      localIndex: localIndexEvaluations++,
                    );
                  } else {
                    end = Evaluation(
                      id: doc.id,
                      marks: -1.0,
                      remarks: doc['endsem_panel_comments'][i]
                              [studentInProject[j].entryNumber] ??
                          'NA',
                      type: 'EndTerm',
                      student: studentInProject[j],
                      faculty: facultyInPanel[i],
                      panelIndex: i,
                      done: false,
                      localIndex: localIndexEvaluations++,
                    );
                  }
                }
                if (mid != null) {
                  evaluations.add(mid);
                }
                if (end != null) {
                  evaluations.add(end);
                }
              }
            }
          }
        });
        setState(() {
          panelEvalutaions[doc['panel_id']] = evaluations;
        });
      }
    });
    loading_teams_and_evaluations = false;
    getAssignedPanels();
  }

  bool updateSearchParameters() {
    setState(() {
      panelID = panelIdController.text.toString().trim().toLowerCase();
      evaluatorName =
          evaluatorNameController.text.toString().trim().toLowerCase();
      course = courseController.text.toString().trim().toLowerCase();
      term = termController.text.toString().trim().toLowerCase();
      yearSemester =
          yearSemesterController.text.toString().trim().toLowerCase();
    });
    if (yearSemester == '' || course == '') {
      return false;
    }
    return true;
  }

  // String? panelID, evaluatorName, term, course, yearSemester;

  void search() {
    if (!updateSearchParameters()) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: FormCustomText(
                text: 'course and year-semester are required files',
              ),
            );
          });
      return;
    }
    setState(() {
      searching = true;
      assignedPanels = [];
    });

    for (AssignedPanel panel in cachedAssignedPanels) {
      bool flag = true;
      if (panelID != null && panelID != '') {
        String temp = panel.id.toString().trim().toLowerCase();
        flag = flag && temp.contains(panelID!);
      }
      if (evaluatorName != null && evaluatorName != '') {
        List<Faculty> temp = panel.panel.evaluators;
        bool internalflag = false;
        for (Faculty faculty in temp) {
          String temp2 = faculty.name.toString().trim().toLowerCase();
          internalflag = internalflag || temp2.contains(evaluatorName!);
        }
        flag = flag && internalflag;
      }
      if (term != null && term != '') {
        String temp = panel.term.toString().trim().toLowerCase();
        flag = flag && temp.contains(term!);
      }
      if (course != null && course != '') {
        String temp = panel.course.toString().trim().toLowerCase();
        flag = flag && temp.contains(course!);
      }
      if (yearSemester != null && yearSemester != '') {
        String sem = panel.semester.toString().trim().toLowerCase();
        String year = panel.year.toString().trim().toLowerCase();
        String temp = '$year-$sem';
        flag = flag && temp.contains(yearSemester!);
      }
      if (flag) {
        setState(() {
          assignedPanels.add(panel);
          if (assignedPanels.length == 2) searching = false;
        });
      }
    }
    setState(() {
      searching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getEvaluations();
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
                      child: (searching || loading_teams_and_evaluations
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
                                          updateEvaluation: updateEvaluation,
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
