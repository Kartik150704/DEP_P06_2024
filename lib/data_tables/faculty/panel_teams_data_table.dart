import 'package:casper/components/confirm_action.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/components/evaluation_submission_form.dart';
import 'package:casper/models/models.dart';
import 'package:casper/seeds.dart';
import 'package:flutter/material.dart';

class PanelTeamsDataTable extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final actionType, assignedPanel, assignedTeams;

  const PanelTeamsDataTable({
    super.key,
    required this.actionType,
    required this.assignedPanel,
    required this.assignedTeams,
  });

  @override
  State<PanelTeamsDataTable> createState() => _PanelTeamsDataTableState();
}

class _PanelTeamsDataTableState extends State<PanelTeamsDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  // TODO: Fetch these values
  final myId = '1',
      totalMidTermMarks = evaluationCriteriasGLOBAL[0].midtermPanel;
  List<StudentData> studentData = [];

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

  void uploadEvaluation(student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: EvaluationSubmissionForm(
              student: student,
            ),
          ),
        );
      },
    );
  }

  void getStudentData() {
    for (final team in widget.assignedTeams) {
      for (final student in team.students) {
        bool myPanel = false;
        double evaluation = -1;

        for (final eval in widget.assignedPanel.evaluations) {
          if (eval.faculty.id == myId) {
            myPanel = true;

            if (eval.student.id == student.id) {
              evaluation = eval.marks;
            }
          }
        }

        setState(() {
          studentData.add(
            StudentData(
              teamId: team.id,
              panelId: widget.assignedPanel.panel.id,
              student: student,
              type: widget.assignedPanel.term,
              evaluation: evaluation.toString(),
              myPanel: myPanel,
            ),
          );
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getStudentData();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.assignedTeams.isEmpty) {
      return SizedBox(
        height: 560,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.grey[300],
                size: 50,
              ),
              const SizedBox(
                width: 10,
              ),
              CustomisedText(
                text: 'No students found',
                color: Colors.grey[300],
                fontSize: 30,
              ),
            ],
          ),
        ),
      );
    } else if (studentData.isEmpty) {
      getStudentData();
    }

    final columns = [
      'Team ID',
      'Student Name',
      'Student Entry Number',
      'Term',
      (widget.actionType == 1 ? 'Action' : 'Evaluation'),
    ];

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
        rows: getRows(studentData),
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
      DataColumn(
        label: CustomisedText(
          text: columns[4],
        ),
        onSort: onSort,
      ),
    ];

    return headings;
  }

  List<DataRow> getRows(List<StudentData> rows) => rows.map(
        (StudentData data) {
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
                width: 200,
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
              SizedBox(
                child: CustomisedText(
                  text: data.type,
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
                              text: '${data.evaluation}/$totalMidTermMarks',
                              color: Colors.black,
                            ),
                            CustomisedButton(
                              text: 'Edit',
                              height: 37,
                              width: 50,
                              onPressed: () => uploadEvaluation(
                                data.student,
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
                          onPressed: () => uploadEvaluation(
                            data.student,
                          ),
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

class StudentData {
  final bool myPanel;
  final String teamId, panelId, type, evaluation;
  final Student student;

  StudentData({
    required this.teamId,
    required this.panelId,
    required this.student,
    required this.evaluation,
    required this.myPanel,
    required this.type,
  });
}
