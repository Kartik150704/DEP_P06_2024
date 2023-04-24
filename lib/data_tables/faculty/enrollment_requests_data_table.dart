import 'package:casper/components/confirm_action.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EnrollmentRequestsDataTable extends StatefulWidget {
  final List<EnrollmentRequest> requests;
  final Map Team_names;

  const EnrollmentRequestsDataTable({
    super.key,
    required this.requests,
    required this.Team_names,
  });

  @override
  State<EnrollmentRequestsDataTable> createState() =>
      _EnrollmentRequestDataTableState();
}

class _EnrollmentRequestDataTableState
    extends State<EnrollmentRequestsDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  void confirmAction(
      bool check, String teamId, String Title, EnrollmentRequest request) {
    if (check) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: ConfirmAction(
                onSubmit: () {
                  // update enrollment request status to 1
                  FirebaseFirestore.instance
                      .collection('enrollment_requests')
                      .doc(request.key_id)
                      .update({'status': '1'});

                  // create project document

                  FirebaseFirestore.instance
                      .collection('team')
                      .where('id', isEqualTo: request.teamId)
                      .get()
                      .then((teamDocs) {
                    var teamDoc = teamDocs.docs[0];
                    List<Student> students = [];
                    for (int i = 0; i < teamDoc['students'].length; i++) {
                      String studentId = teamDoc['students'][i];
                      FirebaseFirestore.instance
                          .collection('student')
                          .where('id', isEqualTo: studentId)
                          .get()
                          .then((studentDocs) {
                        var studentDoc = studentDocs.docs[0];
                        Student student = Student(
                            id: studentId,
                            name: studentDoc['name'],
                            entryNumber: studentId,
                            email: '$studentId@iitrpr.ac.in');
                        students.add(student);
                        if (i == teamDoc['students'].length - 1) {
                          var project = {
                            'chat': [],
                            'description': request.offering.project.description,
                            'instructor_name': request.offering.instructor.name,
                            'offering_id': request.offering.key_id,
                            'panel_ids': [],
                            'semester': request.offering.semester,
                            'year': request.offering.year,
                            'student_ids': List.generate(
                                students.length, (index) => students[index].id),
                            'student_name': List.generate(students.length,
                                (index) => students[index].name),
                            'team_id': request.teamId,
                            'title': request.offering.project.title,
                            'type': request.offering.course,
                          };
                          FirebaseFirestore.instance
                              .collection('projects')
                              .add(project)
                              .then((value) {
                            // add reference to instructor document

                            FirebaseFirestore.instance
                                .collection('instructors')
                                .where('uid',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser?.uid)
                                .get()
                                .then((instructorDocs) {
                              var instructorDoc = instructorDocs.docs[0];
                              List<String> projects = List.generate(
                                  instructorDoc['project_as_head_ids'].length,
                                  (index) =>
                                      instructorDoc['project_as_head_ids']
                                          [index]);
                              projects.add(value.id);
                              var updateData = {
                                'project_as_head_ids': projects,
                                'num_projects_as_head':
                                    projects.length.toString(),
                              };
                              FirebaseFirestore.instance
                                  .collection('instructors')
                                  .doc(instructorDoc.id)
                                  .update(updateData);
                            });

                            // create evaluation document
                            EvaluationCriteria evaluationCriteria;
                            FirebaseFirestore.instance
                                .collection('evaluation_criteria')
                                .where('course',
                                    isEqualTo: request.offering.course)
                                .where('semester',
                                    isEqualTo: request.offering.semester)
                                .where('year', isEqualTo: request.offering.year)
                                .get()
                                .then((evaluationCriteriaDocs) {
                              var evaluationCriteriaDoc =
                                  evaluationCriteriaDocs.docs[0];
                              evaluationCriteria = EvaluationCriteria(
                                id: evaluationCriteriaDoc.id,
                                weeksToConsider: int.parse(
                                    evaluationCriteriaDoc['weeksToConsider']),
                                course: evaluationCriteriaDoc['course'],
                                semester: evaluationCriteriaDoc['semester'],
                                year: evaluationCriteriaDoc['year'],
                                numberOfWeeks: int.parse(
                                    evaluationCriteriaDoc['numberOfWeeks']),
                                regular:
                                    int.parse(evaluationCriteriaDoc['regular']),
                                midtermSupervisor: int.parse(
                                    evaluationCriteriaDoc['midtermSupervisor']),
                                midtermPanel: int.parse(
                                    evaluationCriteriaDoc['midtermPanel']),
                                endtermSupervisor: int.parse(
                                    evaluationCriteriaDoc['endtermSupervisor']),
                                endtermPanel: int.parse(
                                    evaluationCriteriaDoc['endtermPanel']),
                                report:
                                    int.parse(evaluationCriteriaDoc['report']),
                              );
                              var evaluation = {
                                'assigned_panels': [],
                                'endsem_evaluation': [],
                                'endsem_panel_comments': [],
                                'endsem_supervisor': {},
                                'midsem_evaluation': [],
                                'midsem_panel_comments': [],
                                'midsem_supervisor': {},
                                'number_of_evaluations':
                                    evaluationCriteria.numberOfWeeks.toString(),
                                'project_id': value.id,
                                'student_ids': List.generate(students.length,
                                    (index) => students[index].id),
                                'student_names': List.generate(students.length,
                                    (index) => students[index].name),
                                'supervisor_id': request.offering.instructor.id,
                                'weekly_comments': List.generate(
                                    evaluationCriteria.numberOfWeeks,
                                    (index) =>
                                        {for (var e in students) e.id: null}),
                                'weekly_evaluations': List.generate(
                                    evaluationCriteria.numberOfWeeks,
                                    (index) =>
                                        {for (var e in students) e.id: null}),
                              };
                              FirebaseFirestore.instance
                                  .collection('evaluations')
                                  .add(evaluation);
                            });
                          });
                        }
                      });
                    }
                  });
                  Navigator.pop(context);
                },
                text: "You want to accept 'team $teamId' for '$Title'.",
              ),
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: ConfirmAction(
                onSubmit: () {},
                text: "You want to reject 'team $teamId' for '$Title'.",
              ),
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  String teamname(String id) {
    String temp = '';
    for (String name in widget.Team_names[id]) {
      temp = '$temp$name, ';
    }
    if (temp.length >= 2) temp = temp.substring(0, temp.length - 2);
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    final columns = [
      'Project',
      'Team',
      'Students',
      'Action',
    ];

    return Theme(
      data: Theme.of(context).copyWith(
          iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white)),
      child: DataTable(
        dataRowHeight: 50,
        border: TableBorder.all(
          width: 2,
          borderRadius: BorderRadius.circular(2),
          color: const Color.fromARGB(255, 43, 40, 40),
        ),
        sortAscending: isAscending,
        sortColumnIndex: sortColumnIndex,
        columns: getColumns(columns),
        rows: getRows(widget.requests),
        headingRowColor: MaterialStateColor.resolveWith(
          (states) {
            return const Color(0xff12141D);
          },
        ),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    var headings = [
      DataColumn(
        label: CustomisedText(
          text: columns[0],
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: CustomisedText(
          text: columns[1],
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: CustomisedText(
          text: columns[2],
        ),
      ),
      DataColumn(
        label: CustomisedText(
          text: columns[3],
        ),
      ),
    ];

    return headings;
  }

  List<DataRow> getRows(List<EnrollmentRequest> rows) => rows.map(
        (EnrollmentRequest request) {
          final cells = [
            DataCell(
              SizedBox(
                child: CustomisedText(
                  text: request.offering.project.title,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 50,
                child: CustomisedOverflowText(
                  text: request.teamId,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 300,
                child: CustomisedOverflowText(
                  text: teamname(request.teamId),
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              Row(
                children: [
                  CustomisedButton(
                    text: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    height: 30,
                    width: 30,
                    onPressed: () => confirmAction(true, request.teamId,
                        request.offering.project.title, request),
                    elevation: 0,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  CustomisedButton(
                    text: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    height: 30,
                    width: 30,
                    onPressed: () => confirmAction(false, request.teamId,
                        request.offering.project.title, request),
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ];

          return DataRow(
            cells: cells,
            color: MaterialStateProperty.all(
              const Color.fromARGB(255, 212, 203, 216),
            ),
          );
        },
      ).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.requests.sort(
        (panel1, panel2) => compareString(
          ascending,
          panel1.offering.project.title.toString(),
          panel2.offering.project.title.toString(),
        ),
      );
    } else if (columnIndex == 1) {
      widget.requests.sort(
        (panel1, panel2) => compareString(
          ascending,
          panel1.teamId.toString(),
          panel2.teamId.toString(),
        ),
      );
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      (ascending ? value1.compareTo(value2) : value2.compareTo(value1));
}
