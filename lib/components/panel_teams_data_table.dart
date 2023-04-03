import 'package:casper/components/confirm_action.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/components/evaluation_submission_form.dart';
import 'package:casper/entities.dart';
import 'package:flutter/material.dart';

class PanelTeamsDataTable extends StatefulWidget {
  final AssignedPanel assignedPanel;
  // ignore: prefer_typing_uninitialized_variables
  final actionType;

  const PanelTeamsDataTable({
    super.key,
    required this.assignedPanel,
    required this.actionType,
  });

  @override
  State<PanelTeamsDataTable> createState() => _PanelTeamsDataTableState();
}

class _PanelTeamsDataTableState extends State<PanelTeamsDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  // TODO: Fetch these values
  final myId = 1, totalMarks = 10;
  final List<StudentData> studentData = [];

  void confirmAction(teamId, panelId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: ConfirmAction(
              onSubmit: () {},
              text:
                  'You want to remove team \'$teamId\' from panel \'$panelId?\'',
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

  @override
  void initState() {
    super.initState();
    for (final team in widget.assignedPanel.assignedTeams) {
      for (final student in team.students) {
        bool myPanel = false;
        int eval = -1;
        for (final currentEvaluation in widget.assignedPanel.evaluations) {
          if (currentEvaluation.evaluator.id == myId) {
            myPanel = true;
            for (final st in currentEvaluation.evaluation) {
              if (st.studentId == student.id) {
                eval = st.marks;
              }
            }
          }
        }

        studentData.add(StudentData(
          teamId: team.id,
          panelId: widget.assignedPanel.panel.id,
          studentId: student.id,
          studentName: student.name,
          studentEntryNumber: student.entryNumber,
          type:
              '${widget.assignedPanel.course}-${widget.assignedPanel.type}-${widget.assignedPanel.year}-${widget.assignedPanel.semester}',
          evaluation: eval,
          isMyPanel: myPanel,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.assignedPanel.assignedTeams.isEmpty) {
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
    }

    final columns = [
      'Team ID',
      'Student Name',
      'Student Entry Number',
      'Type',
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
                  text: data.studentName,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedText(
                  text: data.studentEntryNumber,
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
              (data.evaluation != -1
                  ? (widget.actionType == 1
                      ? const CustomisedText(
                          text: 'Evaluated',
                          color: Colors.black,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomisedText(
                              text: '${data.evaluation}/$totalMarks',
                              color: Colors.black,
                            ),
                            CustomisedButton(
                              text: 'Edit',
                              height: 37,
                              width: 50,
                              onPressed: () => uploadEvaluation(
                                Student(
                                    name: data.studentName,
                                    entryNumber: data.studentEntryNumber,
                                    id: data.studentId),
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
                            Student(
                                name: data.studentName,
                                entryNumber: data.studentEntryNumber,
                                id: data.studentId),
                          ),
                          elevation: 0,
                        ))),
            ),
          ];

          return DataRow(
            cells: cells,
            color: MaterialStateProperty.all(
              (widget.actionType == 1
                  ? (data.evaluation != -1
                      ? const Color.fromARGB(255, 192, 188, 192)
                      : const Color.fromARGB(255, 212, 203, 216))
                  : (data.evaluation != -1
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
          data1.studentName.toString(),
          data2.studentName.toString(),
        ),
      );
    } else if (columnIndex == 2) {
      studentData.sort(
        (data1, data2) => compareString(
          ascending,
          data1.studentEntryNumber.toString(),
          data2.studentEntryNumber.toString(),
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
  final bool isMyPanel;
  final int teamId, panelId, studentId, evaluation;
  final String studentName, studentEntryNumber, type;

  StudentData({
    required this.teamId,
    required this.panelId,
    required this.studentId,
    required this.studentName,
    required this.studentEntryNumber,
    required this.evaluation,
    required this.isMyPanel,
    required this.type,
  });
}
