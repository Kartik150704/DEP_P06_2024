import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/entities.dart';
import 'package:flutter/material.dart';

class PanelTeamsDataTable extends StatefulWidget {
  final AssignedPanel assignedPanel;

  const PanelTeamsDataTable({
    super.key,
    required this.assignedPanel,
  });

  @override
  State<PanelTeamsDataTable> createState() => _PanelTeamsDataTableState();
}

class _PanelTeamsDataTableState extends State<PanelTeamsDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  final myId = 1;
  final List<StudentData> studentData = [];

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
          studentName: student.name,
          studentEntryNumber: student.entryNumber,
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
      'Evaluation',
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
                width: 300,
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
              (data.evaluation != -1
                  ? CustomisedText(
                      text: data.evaluation.toString(),
                      color: Colors.black,
                    )
                  : (data.isMyPanel
                      ? CustomisedButton(
                          text: const Icon(
                            Icons.open_in_new_rounded,
                            size: 20,
                          ),
                          height: 37,
                          width: double.infinity,
                          onPressed: () {},
                          elevation: 0,
                        )
                      : const CustomisedText(
                          text: 'Not Evaluated',
                          color: Colors.black,
                        ))),
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
  final int teamId, evaluation;
  final String studentName, studentEntryNumber;

  StudentData({
    required this.teamId,
    required this.studentName,
    required this.studentEntryNumber,
    required this.evaluation,
    required this.isMyPanel,
  });
}
