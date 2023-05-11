import 'package:casper/comp/data_not_found.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/comp/customised_overflow_text.dart';
import 'package:casper/comp/customised_text.dart';
import 'package:casper/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FacultyPanelsDataTable extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final userRole, assignedPanels, viewPanel;
  Function? updateEvaluation;

  FacultyPanelsDataTable({
    super.key,
    required this.userRole,
    required this.assignedPanels,
    required this.viewPanel,
    this.updateEvaluation,
  });

  @override
  State<FacultyPanelsDataTable> createState() => _FacultyPanelsDataTableState();
}

class _FacultyPanelsDataTableState extends State<FacultyPanelsDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  late final myId;

  int getNumberOfTeamsEvaluated(AssignedPanel assignedPanel) {
    int count = 0;
    for (Team team in assignedPanel.assignedTeams) {
      int studentsDone = 0;
      int numexpected = 0;

      List<String> students = List.generate(
          team.numberOfMembers, (index) => team.students[index].id);

      for (Evaluation evaluation in assignedPanel.evaluations) {
        // TODO: check null safety
        if ((evaluation.done ?? false) &&
            evaluation.faculty.id == myId &&
            students.contains(evaluation.student.id)) {
          studentsDone += 1;
        }
        if (students.contains(evaluation.student.id) &&
            evaluation.faculty.id == myId) {
          numexpected += 1;
        }
      }
      if (studentsDone == numexpected) {
        count += 1;
      }
    }
    return count;
    // for (Evaluation evaluation in assignedPanel.evaluations) {
    //   if (evaluation.faculty.id == myId) {
    //     count+=1;
    //   }
    // }
    // for (final evaluation in assignedPanel.evaluations) {
    //   if (evaluation.faculty.id == myId) {
    //     count += 1;
    //   }
    // }
    // return (count / 2).round();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myId = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.assignedPanels.isEmpty) {
      return DataNotFound(message: 'No panels found');
    }

    final columns = [
      'Panel',
      'Evaluators',
      'Assigned',
      'Evaluated',
      'Term',
      'View Details',
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
        rows: getRows(widget.assignedPanels),
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
      DataColumn(
        label: CustomisedText(
          text: columns[5],
        ),
      ),
    ];

    return headings;
  }

  List<DataRow> getRows(List<AssignedPanel> rows) => rows.map(
        (AssignedPanel assignedPanel) {
          final cells = [
            DataCell(
              SizedBox(
                child: CustomisedText(
                  text: assignedPanel.panel.id.toString(),
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              Tooltip(
                message: assignedPanel.panel.evaluators
                    .map((e) => e.name)
                    .join(', '),
                child: SizedBox(
                  width: 290,
                  child: CustomisedOverflowText(
                    text: assignedPanel.panel.evaluators
                        .map((e) => e.name)
                        .join(', '),
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedOverflowText(
                  text: assignedPanel.numberOfAssignedTeams.toString(),
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedOverflowText(
                  text: getNumberOfTeamsEvaluated(assignedPanel).toString(),
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedOverflowText(
                  text: assignedPanel.term,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              CustomisedButton(
                text: const Icon(
                  Icons.open_in_new_rounded,
                  size: 20,
                ),
                height: 37,
                width: double.infinity,
                onPressed: () => widget.viewPanel(assignedPanel, 2,
                    updateEvaluation: widget.updateEvaluation),
                elevation: 0,
              ),
            ),
          ];

          return DataRow(
            cells: cells,
            color: MaterialStateProperty.all(
              (assignedPanel.numberOfAssignedTeams ==
                      getNumberOfTeamsEvaluated(assignedPanel)
                  ? const Color(0xff7ae37b)
                  : const Color.fromARGB(255, 208, 219, 144)),
            ),
          );
        },
      ).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.assignedPanels.sort(
        (assignedPanel1, assignedPanel2) => compareString(
            ascending,
            assignedPanel1.panel.id.toString(),
            assignedPanel2.panel.id.toString()),
      );
    } else if (columnIndex == 2) {
      widget.assignedPanels.sort(
        (assignedPanel1, assignedPanel2) => compareString(
            ascending,
            assignedPanel1.numberOfAssignedTeams.toString(),
            assignedPanel2.numberOfAssignedTeams.toString()),
      );
    } else if (columnIndex == 3) {
      widget.assignedPanels.sort(
        (assignedPanel1, assignedPanel2) => compareString(
            ascending,
            getNumberOfTeamsEvaluated(assignedPanel1).toString(),
            getNumberOfTeamsEvaluated(assignedPanel2).toString()),
      );
    } else if (columnIndex == 4) {
      widget.assignedPanels.sort(
        (assignedPanel1, assignedPanel2) =>
            compareString(ascending, assignedPanel1.term, assignedPanel2.term),
      );
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) {
    if (int.tryParse(value1) != null && int.tryParse(value2) != null) {
      return (ascending
          ? int.parse(value1) > int.parse(value2)
              ? 1
              : int.parse(value1) < int.parse(value2)
                  ? -1
                  : 0
          : int.parse(value2) < int.parse(value1)
              ? 1
              : int.parse(value2) > int.parse(value1)
                  ? -1
                  : 0);
    }
    return (ascending ? value1.compareTo(value2) : value2.compareTo(value1));
  }
}
