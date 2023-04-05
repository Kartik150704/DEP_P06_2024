import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/models.dart';
import 'package:flutter/material.dart';

class PanelsDataTable extends StatefulWidget {
  final List<AssignedPanel> assignedPanels;
  // ignore: prefer_typing_uninitialized_variables
  final viewPanel;

  const PanelsDataTable({
    super.key,
    required this.assignedPanels,
    required this.viewPanel,
  });

  @override
  State<PanelsDataTable> createState() => _PanelsDataTableState();
}

class _PanelsDataTableState extends State<PanelsDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

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
      'Number Of Evaluators',
      'Evaluators',
      'Type',
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
                child: CustomisedText(
                  text: assignedPanel.panel.numberOfEvaluators.toString(),
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 400,
                child: CustomisedOverflowText(
                  text: assignedPanel.panel.evaluators
                      .map((e) => e.name)
                      .join(', '),
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              CustomisedOverflowText(
                text:
                    '${assignedPanel.panel.course}-${assignedPanel.panel.year}-${assignedPanel.panel.semester}',
                color: Colors.black,
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
                onPressed: () => widget.viewPanel(assignedPanel, 1),
                elevation: 0,
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
      widget.assignedPanels.sort(
        (panel1, panel2) => compareString(
          ascending,
          panel1.panel.id.toString(),
          panel2.panel.id.toString(),
        ),
      );
    } else if (columnIndex == 1) {
      widget.assignedPanels.sort(
        (panel1, panel2) => compareString(
          ascending,
          panel1.panel.numberOfEvaluators.toString(),
          panel2.panel.numberOfEvaluators.toString(),
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
