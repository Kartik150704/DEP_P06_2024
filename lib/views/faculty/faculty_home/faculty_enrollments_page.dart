import 'dart:math';
import 'package:casper/components/alert_message.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/data_tables/faculty/faculty_enrollments_data_table.dart';
import 'package:casper/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FacultyEnrollmentsPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final userRole, viewProject;

  const FacultyEnrollmentsPage({
    Key? key,
    required this.userRole,
    required this.viewProject,
  }) : super(key: key);

  @override
  State<FacultyEnrollmentsPage> createState() => _FacultyEnrollmentsPageState();
}

class _FacultyEnrollmentsPageState extends State<FacultyEnrollmentsPage> {
  dynamic displayPage;
  bool ischecked = false, loading = true, searching = false;
  final List<Enrollment> enrollments = [];
  String? projectTitle, teamId, studentName, courseCode, yearSemester;
  final projectTitleController = TextEditingController(),
      teamIdController = TextEditingController(),
      studentNameController = TextEditingController(),
      courseCodeController = TextEditingController(text: 'CP303'),
      yearSemesterController = TextEditingController(text: '1999-1');
  final horizontalScrollController = ScrollController(),
      verticalScrollController = ScrollController();
  late EvaluationCriteria evaluationCriteria;
  String currentYearSemester = '';

  void getSupervisorEnrollments() async {
    setState(() {
      enrollments.clear();
    });

    await FirebaseFirestore.instance
        .collection('instructors')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then(
      (snapshot) async {
        if (snapshot.docs.isEmpty ||
            snapshot.docs[0]['project_as_head_ids'].length == 0) {
          setState(() {
            loading = false;
            searching = false;
          });

          return;
        }
        await FirebaseFirestore.instance
            .collection('projects')
            .where(
              FieldPath.documentId,
              whereIn: snapshot.docs[0]['project_as_head_ids'],
            )
            .get()
            .then(
          (value) {
            for (var doc in value.docs) {
              FirebaseFirestore.instance
                  .collection('evaluations')
                  .where('project_id', isEqualTo: doc.id)
                  .get()
                  .then((value) {
                if (value.docs.length == 0) {
                  setState(() {
                    loading = false;
                    searching = false;
                  });
                  print('evaluation not found for ${doc.id}');
                  return;
                }
              });
              // print('here');

              final val = doc.data();
              if (projectTitle != null) {
                if (!val['title']
                    .toLowerCase()
                    .contains(projectTitle!.toLowerCase())) {
                  continue;
                }
              }
              // print('here1');

              if (teamId != null) {
                if (!val['team_id']
                    .toLowerCase()
                    .contains(teamId!.toLowerCase())) {
                  continue;
                }
              }
              // print('here2');

              if (studentName != null) {
                bool flag = false;
                for (String name in val['student_name']) {
                  if (name.toLowerCase().contains(studentName!.toLowerCase())) {
                    flag = true;
                    break;
                  }
                }
                if (flag == false) {
                  continue;
                }
              }

              if (courseCode != null) {
                if (!val['type']
                    .toLowerCase()
                    .contains(courseCode!.toLowerCase())) {
                  continue;
                }
              }

              if (yearSemester != null) {
                String yearSemester = val['year'] + '-' + val['semester'];
                if (!yearSemester
                    .toLowerCase()
                    .contains(yearSemester.toLowerCase())) {
                  continue;
                }
              }

              List<Evaluation> supervisorEvaluations = [];
              Map studentNames = {};
              var temp = List<MapEntry<String, String>>.generate(
                val['student_name'].length,
                (index) => MapEntry(
                    val['student_ids'][index], val['student_name'][index]),
              );
              // print(temp);
              studentNames.addEntries(temp);
              FirebaseFirestore.instance
                  .collection('evaluations')
                  .where('project_id', isEqualTo: doc.id)
                  .get()
                  .then(
                (value) {
                  if (value.docs.length == 0) {
                    setState(() {
                      loading = false;
                      searching = false;
                    });
                    return;
                  }
                  var evaludationDoc = value.docs[0];
                  List<String> studentIds =
                      evaludationDoc['weekly_evaluations'][0].keys.toList();
                  for (String studentId in studentIds) {
                    for (int week = 0;
                        week <
                            int.tryParse(
                                evaludationDoc['number_of_evaluations'])!;
                        week++) {
                      if (evaludationDoc['weekly_evaluations'][week]
                              [studentId] ==
                          null) {
                        continue;
                      }
                      Evaluation evaluation = Evaluation(
                        id: '1',
                        marks: double.tryParse(
                            evaludationDoc['weekly_evaluations'][week]
                                [studentId])!,
                        remarks: evaludationDoc['weekly_comments'][week]
                            [studentId],
                        type: 'week-${week + 1}',
                        student: Student(
                            id: studentId,
                            email: '$studentId@iitrpr.ac.in',
                            entryNumber: studentId,
                            name: studentNames[studentId]),
                        faculty: Faculty(
                          id: evaludationDoc['supervisor_id'],
                          name: val['instructor_name'],
                          //TODO: fix email
                          email: 'temp@iitrpr.ac.iin',
                        ),
                      );
                      supervisorEvaluations.add(evaluation);
                    }
                    for (int ii = 0; ii < 2; ii++) {
                      if (evaludationDoc['midsem_supervisor'][studentId] ==
                          null) {
                        continue;
                      }
                      Evaluation evaluation = Evaluation(
                        id: '1',
                        marks: double.tryParse(
                            evaludationDoc['midsem_supervisor'][studentId])!,
                        remarks: evaludationDoc['midsem_panel_comments'][ii]
                            [studentId],
                        type: 'midterm-supervisor',
                        student: Student(
                            id: studentId,
                            email: '$studentId@iitrpr.ac.in',
                            entryNumber: studentId,
                            name: studentNames[studentId]),
                        faculty: Faculty(
                          id: evaludationDoc['supervisor_id'],
                          name: val['instructor_name'],
                          //TODO: fix email
                          email: 'temp@iitrpr.ac.iin',
                        ),
                      );
                      supervisorEvaluations.add(evaluation);

                      evaluation = Evaluation(
                        id: '1',
                        marks: double.tryParse(
                            evaludationDoc['endsem_supervisor'][studentId])!,
                        remarks: evaludationDoc['endsem_panel_comments'][ii]
                            [studentId],
                        type: 'endterm-supervisor',
                        student: Student(
                            id: studentId,
                            email: '$studentId@iitrpr.ac.in',
                            entryNumber: studentId,
                            name: studentNames[studentId]),
                        faculty: Faculty(
                          id: evaludationDoc['supervisor_id'],
                          name: val['instructor_name'],
                          //TODO: fix email
                          email: 'temp@iitrpr.ac.iin',
                        ),
                      );
                      supervisorEvaluations.add(evaluation);
                    }
                  }

                  setState(() {
                    enrollments.add(
                      Enrollment(
                        id: doc.id,
                        offering: Offering(
                          id: val['offering_id'],
                          instructor: Faculty(
                            id: FirebaseAuth.instance.currentUser!.uid,
                            name: val['instructor_name'],
                            email: FirebaseAuth.instance.currentUser!.email
                                .toString(),
                          ),
                          course: val['type'],
                          semester: val['semester'],
                          year: val['year'],
                          project: Project(
                            id: doc.id,
                            title: val['title'],
                            description: val['description'],
                          ),
                        ),
                        team: Team(
                          id: val['team_id'],
                          numberOfMembers: val['student_ids'].length,
                          students: List<Student>.generate(
                            val['student_ids'].length,
                            (index) => Student(
                              id: val['student_ids'][index],
                              name: val['student_name'][index],
                              entryNumber: val['student_ids'][index],
                              email:
                                  '${val['student_ids'][index]}@iitrpr.ac.in',
                            ),
                          ),
                        ),
                        supervisorEvaluations: supervisorEvaluations,
                      ),
                    );
                  });
                  setState(() {
                    loading = false;
                    searching = false;
                  });
                },
              );
            }
          },
        );
      },
    );
    // print('called');
    setState(() {
      loading = false;
      searching = false;
    });
    // print(enrollments.length);
  }

  Future<void> getEvaluationCriteria() async {
    EvaluationCriteria evalcrit;
    await FirebaseFirestore.instance
        .collection('evaluation_criteria')
        .where('course', isEqualTo: courseCodeController.text.trim())
        .where('semester', isEqualTo: currentYearSemester.split('-')[1])
        .where('year', isEqualTo: currentYearSemester.split('-')[0])
        .get()
        .then((evaluationCriteriaDocs) async {
      var evaluationCriteriaDoc = evaluationCriteriaDocs.docs[0];
      evalcrit = EvaluationCriteria(
        id: evaluationCriteriaDoc.id,
        weeksToConsider: int.parse(evaluationCriteriaDoc['weeksToConsider']),
        course: evaluationCriteriaDoc['course'],
        semester: evaluationCriteriaDoc['semester'],
        year: evaluationCriteriaDoc['year'],
        numberOfWeeks: int.parse(evaluationCriteriaDoc['numberOfWeeks']),
        regular: int.parse(evaluationCriteriaDoc['regular']),
        midtermSupervisor:
            int.parse(evaluationCriteriaDoc['midtermSupervisor']),
        midtermPanel: int.parse(evaluationCriteriaDoc['midtermPanel']),
        endtermSupervisor:
            int.parse(evaluationCriteriaDoc['endtermSupervisor']),
        endtermPanel: int.parse(evaluationCriteriaDoc['endtermPanel']),
        report: int.parse(evaluationCriteriaDoc['report']),
      );
      setState(() {
        evaluationCriteria = evalcrit;
      });
    });
  }


  void getSession() async {
    await FirebaseFirestore.instance
        .collection('current_session')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        var doc = value.docs[0];
        setState(() {
          currentYearSemester = doc['year'] + '-' + doc['semester'];
          yearSemesterController.text = currentYearSemester;
        });
      } else {
        setState(() {
          currentYearSemester = '2022-2';
        });
        print(
            'faculty_enrollment_requests_page.dart -> no valid session found');
      }
    });
    await getEvaluationCriteria();
  }


  @override
  void initState() {
    super.initState();
    updateSearchParameters();
    searching = true;
    getSupervisorEnrollments();
    getSession();
  }

  bool updateSearchParameters() {
    setState(() {
      projectTitle = projectTitleController.text == ''
          ? null
          : projectTitleController.text.trim();
      teamId =
          teamIdController.text == '' ? null : teamIdController.text.trim();
      studentName = studentNameController.text == ''
          ? null
          : studentNameController.text.trim();
      courseCode = courseCodeController.text == ''
          ? null
          : courseCodeController.text.trim();
      yearSemester = yearSemesterController.text == ''
          ? null
          : yearSemesterController.text.trim();
    });
    if (courseCode == null || yearSemester == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertMessage(
              message: 'Course code and session are required fields');
        },
      );
      return false;
    }
    return true;
  }

  void search() {
    if (searching) {
      return;
    }
    setState(() {
      searching = true;
    });
    getSupervisorEnrollments();
    getEvaluationCriteria();
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
      return Expanded(
        child: Container(
          width: double.infinity,
          color: const Color(0xff302c42),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ),
        ),
      );
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
                        text: 'My Enrollments',
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
                        message: 'Project Title',
                        child: SearchTextField(
                          textEditingController: projectTitleController,
                          hintText: 'Project',
                          width: 170 * wfem,
                        ),
                      ),
                      SizedBox(
                        width: 20 * wfem,
                      ),
                      Tooltip(
                        message: 'Team Identification Number',
                        child: SearchTextField(
                          textEditingController: teamIdController,
                          hintText: 'Team Identification',
                          width: 170 * wfem,
                        ),
                      ),
                      SizedBox(
                        width: 20 * wfem,
                      ),
                      Tooltip(
                        message: 'Student\'s Name',
                        child: SearchTextField(
                          textEditingController: studentNameController,
                          hintText: 'Student\'s Name',
                          width: 170 * wfem,
                        ),
                      ),
                      SizedBox(
                        width: 20 * wfem,
                      ),
                      Tooltip(
                        message: 'Course Code',
                        child: SearchTextField(
                          textEditingController: courseCodeController,
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
                          onPressed: () {
                            if (updateSearchParameters()) search();
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
                                        child: FacultyEnrollmentsDataTable(
                                          enrollments: enrollments,
                                          userRole: widget.userRole,
                                          viewProject: widget.viewProject,
                                          evaluationCriteria:
                                              evaluationCriteria,
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
