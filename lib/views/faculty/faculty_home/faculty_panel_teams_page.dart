import 'dart:math';

import 'package:casper/components/add_teams_form.dart';
import 'package:casper/comp/customised_overflow_text.dart';
import 'package:casper/comp/customised_text.dart';
import 'package:casper/data_tables/faculty/faculty_panel_teams_data_table.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/models/models.dart';
import 'package:casper/models/seeds.dart';
import 'package:casper/views/shared/loading_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FacultyPanelTeamsPage extends StatefulWidget {
  final int actionType;
  final String userRole;
  AssignedPanel assignedPanel;
  Function? updateEvaluation;

  FacultyPanelTeamsPage({
    Key? key,
    required this.actionType,
    required this.userRole,
    required this.assignedPanel,
    this.updateEvaluation,
  }) : super(key: key);

  @override
  State<FacultyPanelTeamsPage> createState() => _FacultyPanelTeamsPageState();
}

class _FacultyPanelTeamsPageState extends State<FacultyPanelTeamsPage> {
  bool loading = true, searching = false;
  List<Team> assignedTeams = [];
  final teamIdController = TextEditingController(),
      studentNameController = TextEditingController(),
      studentEntryNumberController = TextEditingController();
  final horizontalScrollController = ScrollController(),
      verticalScrollController = ScrollController();
  late final AssignedPanel cachedAssignedPanel;
  String? teamId, studentName, studentEntryNumber;

  late AssignedPanel assignedPanelFiltered;

  bool updateSearchParameters() {
    teamId = teamIdController.text.toString().toLowerCase().trim();
    studentName = studentNameController.text.toString().toLowerCase().trim();
    studentEntryNumber =
        studentEntryNumberController.text.toString().toLowerCase().trim();
    return true;
  }

  Future<void> search() async {
    if (!updateSearchParameters()) {
      return;
    }
    print('searching');
    setState(() {
      searching = true;
    });
    List<Evaluation> tempevaluations = [];
    Map notToBeIncluded = {};
    for (Evaluation evaluation in cachedAssignedPanel.evaluations) {
      bool flag = true;
      if (!evaluation.student.id
          .toLowerCase()
          .contains(studentEntryNumber ?? '')) {
        flag = false;
      }
      // if (!evaluation.student.name.toLowerCase().contains(studentName ?? '')) {
      //   flag = false;
      // }
      // print(flag);
      if (flag) {
        tempevaluations.add(evaluation);
      } else {
        notToBeIncluded[evaluation.student.id] = true;
        notToBeIncluded[evaluation.student.name] = true;
      }
    }
    List<Team> tempTeams = cachedAssignedPanel.assignedTeams;
    // for (Team team in cachedAssignedPanel.assignedTeams) {
    //   bool flag = true;
    //   if (!team.id.toLowerCase().contains(teamId ?? '')) {
    //     flag = false;
    //   }
    //   bool tempflag = false;
    //   for (Student student in team.students) {
    //     if(student.)
    //   }
    //   print(flag);
    //   if (flag) {
    //     tempTeams.add(team);
    //   }
    // }
    setState(() {
      assignedPanelFiltered = AssignedPanel(
          id: cachedAssignedPanel.id,
          course: cachedAssignedPanel.course,
          term: cachedAssignedPanel.term,
          semester: cachedAssignedPanel.term,
          year: cachedAssignedPanel.term,
          numberOfAssignedTeams: 0,
          panel: cachedAssignedPanel.panel,
          assignedTeams: tempTeams,
          evaluations: tempevaluations);
      searching = false;
      // loading = false;
    });

    print(assignedPanelFiltered.evaluations.length);
  }

  void getPanelData() async {
    int localIndexEvaluations = 0;
    if (widget.assignedPanel.assignedProjectIds!.isEmpty) {
      setState(() {
        loading = false;
      });
      return;
    }
    List<String> releasedEvents = [];
    List<Evaluation> evaluations = [];
    List<Faculty> facultyInPanel = [];
    String panelType = widget.assignedPanel.term;
    String panel_id = widget.assignedPanel.id;

    facultyInPanel = widget.assignedPanel.panel.evaluators;

    if (widget.assignedPanel.assignedProjectIds!.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('released_events')
        .where('semester', isEqualTo: widget.assignedPanel.semester)
        .where('year', isEqualTo: widget.assignedPanel.year)
        .where('course', isEqualTo: widget.assignedPanel.course)
        .get()
        .then((releasedEventsValue) async {
      if (releasedEventsValue.docs.length == 1) {
        releasedEvents = releasedEventsValue.docs[0]['events'].keys.toList();
      }
    });
    // print(releasedEvents);
    await FirebaseFirestore.instance
        .collection('evaluations')
        .where('project_id', whereIn: widget.assignedPanel.assignedProjectIds)
        .get()
        .then((evaluationValue) async {
      for (var doc in evaluationValue.docs) {
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

        widget.assignedPanel.assignedTeams.add(team);
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

    widget.assignedPanel.evaluations = evaluations;

    //*********
    setState(() {
      cachedAssignedPanel = widget.assignedPanel;
      assignedPanelFiltered = widget.assignedPanel;
      loading = false;
    });
    // print('assigned teams length ${widget.assignedPanel.assignedTeams.length}');
  }

  void addTeams() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: AddTeamsForm(),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.actionType == 1) {
      getPanelData();
    } else {
      cachedAssignedPanel = widget.assignedPanel;
      assignedPanelFiltered = widget.assignedPanel;
      loading = false;
    }
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
      child: Scaffold(
        body: Container(
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomisedText(
                          text: 'Panel ${widget.assignedPanel.panel.id}: ',
                          fontSize: 50,
                        ),
                        Container(
                          height: 50,
                          alignment: Alignment.bottomLeft,
                          child: CustomisedOverflowText(
                            text:
                                ' ${widget.assignedPanel.panel.evaluators.map((e) => e.name).join(', ')}',
                            fontSize: 30,
                          ),
                        ),
                        Container(
                          height: 45,
                          alignment: Alignment.bottomRight,
                          child: CustomisedOverflowText(
                            text:
                                '  [${widget.assignedPanel.course}, ${widget.assignedPanel.year}-${widget.assignedPanel.semester}, ${widget.assignedPanel.term}]',
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
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
                        SearchTextField(
                          textEditingController: teamIdController,
                          hintText: 'Team Identification',
                          width: 170 * wfem,
                        ),
                        SizedBox(
                          width: 20 * wfem,
                        ),
                        SearchTextField(
                          textEditingController: studentNameController,
                          hintText: 'Student Name',
                          width: 170 * wfem,
                        ),
                        SizedBox(
                          width: 20 * wfem,
                        ),
                        SearchTextField(
                          textEditingController: studentEntryNumberController,
                          hintText: 'Student Entry Number',
                          width: 170 * wfem,
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
                            onPressed: () async {
                              await search();
                            },
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
                                          child: FacultyPanelTeamsDataTable(
                                            actionType: widget.actionType,
                                            assignedPanel:
                                                assignedPanelFiltered,
                                            assignedTeams: assignedPanelFiltered
                                                .assignedTeams,
                                            //TODO: remove, not used anymore
                                            updateEvaluation:
                                                widget.updateEvaluation,
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
        floatingActionButton: (widget.actionType == 1
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 7, 0),
                    child: Tooltip(
                      message: 'Add Team(s)',
                      child: FloatingActionButton(
                        backgroundColor:
                            const Color.fromARGB(255, 212, 203, 216),
                        splashColor: Colors.black,
                        hoverColor: Colors.grey,
                        onPressed: addTeams,
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 65,
                  ),
                ],
              )
            : Container()),
      ),
    );
  }
}
