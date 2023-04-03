import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/entities.dart';
import 'package:flutter/material.dart';

class AssignedPanelsDataTable extends StatefulWidget {
  final List<AssignedPanel> assignedPanels;
  final String userRole;
  // ignore: prefer_typing_uninitialized_variables
  final viewPanel;

  const AssignedPanelsDataTable({
    super.key,
    required this.assignedPanels,
    required this.userRole,
    required this.viewPanel,
  });

  @override
  State<AssignedPanelsDataTable> createState() =>
      _AssignedPanelsDataTableState();
}

class _AssignedPanelsDataTableState extends State<AssignedPanelsDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  late int myId = 1;
  int getNumberOfTeamsEvaluated(AssignedPanel assignedPanel) {
    int count = 0;
    for (final evaluation in assignedPanel.evaluations) {
      if (evaluation.evaluator.id == myId) {
        count += 1;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.assignedPanels.isEmpty) {
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
                text: 'No panels found',
                color: Colors.grey[300],
                fontSize: 30,
              ),
            ],
          ),
        ),
      );
    }

    final columns = [
      'ID',
      'Evaluators',
      'Teams Assigned',
      'Teams Evaluated',
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
              SizedBox(
                width: 350,
                child: CustomisedOverflowText(
                  text: assignedPanel.panel.evaluators
                      .map((e) => e.name)
                      .join(', '),
                  color: Colors.black,
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
              CustomisedButton(
                text: const Icon(
                  Icons.open_in_new_rounded,
                  size: 20,
                ),
                height: 37,
                width: double.infinity,
                onPressed: () => widget.viewPanel(assignedPanel, 2),
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
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      (ascending ? value1.compareTo(value2) : value2.compareTo(value1));
}
