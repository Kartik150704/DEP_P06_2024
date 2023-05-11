import 'package:casper/comp/data_not_found.dart';
import 'package:casper/components/confirm_action.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/comp/customised_overflow_text.dart';
import 'package:casper/comp/customised_text.dart';
import 'package:casper/components/evaluation_submission_form.dart';
import 'package:casper/models/models.dart';
import 'package:casper/models/seeds.dart';
import 'package:casper/views/shared/loading_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FacultyPanelTeamsDataTable extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final actionType, assignedPanel, assignedTeams;
  Function? updateEvaluation;

  FacultyPanelTeamsDataTable({
    super.key,
    required this.actionType,
    required this.assignedPanel,
    required this.assignedTeams,
    this.updateEvaluation,
  });

  @override
  State<FacultyPanelTeamsDataTable> createState() =>
      _FacultyPanelTeamsDataTableState();
}

class _FacultyPanelTeamsDataTableState
    extends State<FacultyPanelTeamsDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  // TODO: Fetch these values
  final myId = FirebaseAuth.instance.currentUser?.uid;
  EvaluationCriteria evaluationCriteria = evaluationCriteriasGLOBAL[0];

  List<StudentData1> studentData = [];

  late AssignedPanel assignedPanel;
  late var assignedTeams;
  late var rows;
  bool loading = true;

  void confirmAction(teamId, panelId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: ConfirmAction(
              onSubmit: () {},
              text:
                  '\'Team $teamId\' will be permanently removed from \'Panel $panelId\'.',
            ),
          ),
        );
      },
    );
  }

  void updateEvaluation(Evaluation evaluation) {
    int local_idx = evaluation.localIndex!;
    for (int i = 0; i < assignedPanel.evaluations.length; i++) {
      if (assignedPanel.evaluations[i].localIndex == local_idx) {
        setState(() {
          assignedPanel.evaluations[i] = evaluation;
        });
      }
    }
    refresh();
  }

  void refresh() {
    setState(() {
      studentData = [];
    });
    getStudentData();
    setState(() {
      rows = getRows(studentData);
    });
  }

  void uploadEvaluation(StudentData1 studentData) {
    // print(studentData.evaluationObject.id);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: EvaluationSubmissionForm(
              studentdata: studentData,
              updateEvaluation: updateEvaluation,
            ),
          ),
        );
      },
    );
  }

  void getStudentData() {
    for (final team in assignedTeams) {
      for (final student in team.students) {
        bool myPanel = false;
        double evaluation = -1;
        late Evaluation evaluationObj;
        // int c = 1;

        for (final eval in assignedPanel.evaluations) {
          // print(c++);
          if (eval.faculty.id == myId) {
            myPanel = true;
            if (eval.student.id == student.id) {
              evaluation = eval.marks;
              evaluationObj = eval;
              setState(() {
                studentData.add(
                  StudentData1(
                    teamId: team.id,
                    panelId: assignedPanel.panel.id,
                    student: student,
                    type: evaluationObj.type,
                    evaluation: evaluation.toString(),
                    myPanel: myPanel,
                    evaluationObject: evaluationObj,
                  ),
                );
              });
            }
          }
        }
      }
    }
  }

  void getCriteriaDetails() async {
    String sem = '', year = '';
    await FirebaseFirestore.instance
        .collection('current_session')
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        sem = value.docs[0]['semester'];
        year = value.docs[0]['year'];
      }
    });
    String course = assignedPanel.course;

    await FirebaseFirestore.instance
        .collection('evaluation_criteria')
        .where('semester', isEqualTo: sem)
        .where('year', isEqualTo: year)
        .where('course', isEqualTo: course)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        var doc = value.docs[0];
        setState(() {
          evaluationCriteria = EvaluationCriteria(
              id: doc.id,
              weeksToConsider: int.parse(doc['weeksToConsider']),
              course: doc['course'],
              semester: doc['semester'],
              year: doc['year'],
              numberOfWeeks: int.parse(doc['numberOfWeeks']),
              regular: int.parse(doc['regular']),
              midtermSupervisor: int.parse(doc['midtermSupervisor']),
              midtermPanel: int.parse(doc['midtermPanel']),
              endtermSupervisor: int.parse(doc['endtermSupervisor']),
              endtermPanel: int.parse(doc['endtermPanel']),
              report: int.parse(doc['report']));
        });
      }
    });
    setState(() {
      loading = false;
    });
    rows = getRows(studentData);
  }

  @override
  void initState() {
    super.initState();
    print(widget.assignedPanel.evaluations.length);
    assignedPanel = widget.assignedPanel;
    assignedTeams = widget.assignedTeams;
    getStudentData();
    getCriteriaDetails();
    // print(studentData.length);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.assignedTeams.isEmpty) {
      return DataNotFound(message: 'No teams found');
    }

    final columns = [
      'Team ID',
      'Student Name',
      'Student Entry Number',
      (widget.actionType == 1 ? 'Action' : 'Evaluation'),
    ];
    if (loading) {
      return const LoadingPage();
    }
    return Theme(
      data: Theme.of(context).copyWith(
          iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white)),
      child: DataTable(
        border: TableBorder.all(
          width: 2,
          borderRadius: BorderRadius.circular(2),
          color: const Color.fromARGB(255, 43, 40, 40),
        ),
        sortAscending: isAscending,
        sortColumnIndex: sortColumnIndex,
        columns: getColumns(columns),
        rows: rows,
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
        onSort: onSort,
      ),
      DataColumn(
        label: CustomisedText(
          text: columns[3],
        ),
        onSort: onSort,
      ),
    ];

    return headings;
  }

  List<DataRow> getRows(List<StudentData1> rows) => rows.map(
        (StudentData1 data) {
          final cells = [
            DataCell(
              SizedBox(
                child: CustomisedText(
                  text: data.teamId.toString(),
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 250,
                child: CustomisedOverflowText(
                  text: data.student.name,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedText(
                  text: data.student.entryNumber,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              (data.evaluation.compareTo('-1') != 0
                  ? (widget.actionType == 1
                      ? const CustomisedText(
                          text: 'Evaluated',
                          color: Colors.black,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomisedText(
                              text: '${data.evaluation}/' +
                                  (data.evaluationObject.type == 'MidTerm'
                                      ? '${evaluationCriteria.midtermPanel}'
                                      : '${evaluationCriteria.endtermPanel}'),
                              color: Colors.black,
                            ),
                            CustomisedButton(
                              text: 'Edit',
                              height: 37,
                              width: 50,
                              onPressed: () => uploadEvaluation(
                                data,
                              ),
                              elevation: 0,
                            )
                          ],
                        ))
                  : (widget.actionType == 1
                      ? CustomisedButton(
                          text: 'Remove Team',
                          height: 37,
                          width: double.infinity,
                          onPressed: () =>
                              confirmAction(data.teamId, data.panelId),
                          elevation: 0,
                        )
                      : CustomisedButton(
                          text: 'Upload',
                          height: 37,
                          width: double.infinity,
                          onPressed: () => uploadEvaluation(data),
                          elevation: 0,
                        ))),
            ),
          ];

          return DataRow(
            cells: cells,
            color: MaterialStateProperty.all(
              (widget.actionType == 1
                  ? (data.evaluation.compareTo('-1') != 0
                      ? const Color.fromARGB(255, 192, 188, 192)
                      : const Color.fromARGB(255, 212, 203, 216))
                  : (data.evaluation.compareTo('-1') != 0
                      ? const Color(0xff7ae37b)
                      : const Color.fromARGB(255, 208, 219, 144))),
            ),
          );
        },
      ).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      studentData.sort(
        (data1, data2) => compareString(
          ascending,
          data1.teamId.toString(),
          data2.teamId.toString(),
        ),
      );
    } else if (columnIndex == 1) {
      studentData.sort(
        (data1, data2) => compareString(
          ascending,
          data1.student.name,
          data2.student.name,
        ),
      );
    } else if (columnIndex == 2) {
      studentData.sort(
        (data1, data2) => compareString(
          ascending,
          data1.student.entryNumber,
          data2.student.entryNumber,
        ),
      );
    } else if (columnIndex == 3) {
      studentData.sort(
        (data1, data2) => compareString(
          ascending,
          data1.type,
          data2.type,
        ),
      );
    } else if (columnIndex == 4) {
      studentData.sort(
        (data1, data2) => compareString(
          ascending,
          data1.evaluation.toString(),
          data2.evaluation.toString(),
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

class StudentData1 {
  final bool myPanel;
  final String teamId, panelId, type, evaluation;
  final Student student;
  final Evaluation evaluationObject;

  StudentData1({
    required this.teamId,
    required this.panelId,
    required this.student,
    required this.evaluation,
    required this.myPanel,
    required this.type,
    required this.evaluationObject,
  });
}
