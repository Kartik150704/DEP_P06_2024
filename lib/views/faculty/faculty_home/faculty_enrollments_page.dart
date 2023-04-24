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
      courseCodeController = TextEditingController(text: 'CP302'),
      yearSemesterController = TextEditingController(text: '2023-1');

  void getSupervisorEnrollments() {
    setState(() {
      enrollments.clear();
    });

    FirebaseFirestore.instance
        .collection('instructors')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then(
      (snapshot) {
        FirebaseFirestore.instance
            .collection('projects')
            .where(
              FieldPath.documentId,
              whereIn: snapshot.docs[0]['project_as_head_ids'],
            )
            .get()
            .then(
          (value) {
            for (var doc in value.docs) {
              final val = doc.data();
              if (projectTitle != null) {
                if (!val['title']
                    .toLowerCase()
                    .contains(projectTitle!.toLowerCase())) {
                  continue;
                }
              }
              if (teamId != null) {
                if (!val['team_id']
                    .toLowerCase()
                    .contains(teamId!.toLowerCase())) {
                  continue;
                }
              }

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
              studentNames.addEntries(temp);
              FirebaseFirestore.instance
                  .collection('evaluations')
                  .where('project_id', isEqualTo: doc.id)
                  .get()
                  .then(
                (value) {
                  var evaludationDoc = value.docs[0];
                  List<String> studentIds =
                      evaludationDoc['weekly_evaluations'][0].keys.toList();
                  for (String studentId in studentIds) {
                    for (int week = 0;
                        week <
                            int.tryParse(
                                evaludationDoc['number_of_evaluations'])!;
                        week++) {
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
  }

  @override
  void initState() {
    super.initState();
    updateSearchParameters();
    getSupervisorEnrollments();
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
          return const AlertDialog(
            title: Center(
              child: Text('Course and Session are required'),
            ),
          );
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
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth;

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
                        width: 33 * fem,
                      ),
                      Tooltip(
                        message: 'Project Title',
                        child: SearchTextField(
                          textEditingController: projectTitleController,
                          hintText: 'Project',
                          width: 170 * fem,
                        ),
                      ),
                      SizedBox(
                        width: 20 * fem,
                      ),
                      Tooltip(
                        message: 'Team Identification Number',
                        child: SearchTextField(
                          textEditingController: teamIdController,
                          hintText: 'Team Identification',
                          width: 170 * fem,
                        ),
                      ),
                      SizedBox(
                        width: 20 * fem,
                      ),
                      Tooltip(
                        message: 'Student\'s Name',
                        child: SearchTextField(
                          textEditingController: studentNameController,
                          hintText: 'Student\'s Name',
                          width: 170 * fem,
                        ),
                      ),
                      SizedBox(
                        width: 20 * fem,
                      ),
                      Tooltip(
                        message: 'Course Code',
                        child: SearchTextField(
                          textEditingController: courseCodeController,
                          hintText: 'Course',
                          width: 170 * fem,
                        ),
                      ),
                      SizedBox(
                        width: 20 * fem,
                      ),
                      Tooltip(
                        message: 'Session',
                        child: SearchTextField(
                          textEditingController: yearSemesterController,
                          hintText: 'Session',
                          width: 170 * fem,
                        ),
                      ),
                      SizedBox(
                        width: 25 * fem,
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
                    width: 1200 * fem,
                    height: 525 * fem,
                    margin: EdgeInsets.fromLTRB(40, 15, 80 * fem, 0),
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
                              height: 500 * fem,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: FacultyEnrollmentsDataTable(
                                enrollments: enrollments,
                                userRole: widget.userRole,
                                viewProject: widget.viewProject,
                              ),
                            )),
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
