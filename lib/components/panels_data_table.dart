import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/faculty/faculty_panels_page.dart';
import 'package:flutter/material.dart';

class PanelsDataTable extends StatefulWidget {
  final List<Panel> panels;
  final String role;
  // final showProject;

  const PanelsDataTable({
    super.key,
    required this.panels,
    required this.role,
    // required this.showProject,
  });

  @override
  State<PanelsDataTable> createState() => _PanelsDataTableState();
}

class _PanelsDataTableState extends State<PanelsDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  Widget build(BuildContext context) {
    if (widget.panels.isEmpty) {
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
      'Panel',
      'Evaluators',
      'Assigned',
      'Evaluated',
      'Type',
      'Semester',
      'Year',
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
        rows: getRows(widget.panels),
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
        onSort: onSort,
      ),
      DataColumn(
        label: CustomisedText(
          text: columns[6],
        ),
        onSort: onSort,
      ),
    ];

    return headings;
  }

  List<DataRow> getRows(List<Panel> rows) => rows.map(
        (Panel panel) {
          final cells = [
            DataCell(
              SizedBox(
                child: CustomisedText(
                  text: panel.number,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 250,
                child: TextButton(
                  onPressed: () {},
                  child: CustomisedOverflowText(
                    text: panel.evaluators,
                    color: Colors.blue[900],
                    selectable: false,
                  ),
                ),
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedOverflowText(
                  text: panel.teamsAssigned,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedOverflowText(
                  text: panel.teamsEvaluated,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 100,
                child: CustomisedOverflowText(
                  text: panel.type,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              CustomisedText(
                text: panel.semester,
                color: Colors.black,
              ),
            ),
            DataCell(
              CustomisedText(
                text: panel.year,
                color: Colors.black,
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
      widget.panels.sort(
        (panel1, panel2) =>
            compareString(ascending, panel1.number, panel2.number),
      );
    } else if (columnIndex == 2) {
      widget.panels.sort(
        (panel1, panel2) => compareString(
            ascending, panel1.teamsAssigned, panel2.teamsAssigned),
      );
    } else if (columnIndex == 3) {
      widget.panels.sort(
        (panel1, panel2) => compareString(
            ascending, panel1.teamsEvaluated, panel2.teamsEvaluated),
      );
    } else if (columnIndex == 4) {
      widget.panels.sort(
        (panel1, panel2) => compareString(ascending, panel1.type, panel2.type),
      );
    } else if (columnIndex == 5) {
      widget.panels.sort(
        (panel1, panel2) =>
            compareString(ascending, panel1.semester, panel2.semester),
      );
    } else if (columnIndex == 6) {
      widget.panels.sort(
        (panel1, panel2) => compareString(ascending, panel1.year, panel2.year),
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
