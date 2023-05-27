import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/components/data_not_found.dart';
import 'package:casper/models/models.dart';
import 'package:flutter/material.dart';

class CoordinatorCriteriaManagementDataTable extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final userRole, evaluationCriterias, viewProject;

  const CoordinatorCriteriaManagementDataTable({
    super.key,
    required this.userRole,
    required this.evaluationCriterias,
    required this.viewProject,
  });

  @override
  State<CoordinatorCriteriaManagementDataTable> createState() =>
      _CoordinatorCriteriaManagementDataTableState();
}

class _CoordinatorCriteriaManagementDataTableState
    extends State<CoordinatorCriteriaManagementDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.evaluationCriterias.isEmpty) {
      return DataNotFound(message: 'No criterias found');
    }

    final columns = [
      'Weeks (T)',
      'Regular',
      'Midterm (S + P)',
      'Endterm (S + P)',
      'Report',
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
        rows: getRows(widget.evaluationCriterias),
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
        label: Tooltip(
          message: 'Number Of Best Weeks To Consider (Total Number Of Weeks)',
          child: CustomisedText(
            text: columns[0],
          ),
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: Tooltip(
          message: 'Regular Evaluations Weightage',
          child: CustomisedText(
            text: columns[1],
          ),
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: Tooltip(
          message: 'Midterm Weightage (Supervisor + Panel)',
          child: CustomisedText(
            text: columns[2],
          ),
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: Tooltip(
          message: 'Endterm Weightage (Supervisor + Panel)',
          child: CustomisedText(
            text: columns[3],
          ),
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: Tooltip(
          message: 'Report Weightage',
          child: CustomisedText(
            text: columns[4],
          ),
        ),
        onSort: onSort,
      ),
    ];

    return headings;
  }

  List<DataRow> getRows(List<EvaluationCriteria> rows) => rows.map(
        (EvaluationCriteria criteria) {
          final cells = [
            DataCell(
              SizedBox(
                child: CustomisedOverflowText(
                  text:
                      '${criteria.weeksToConsider} (${criteria.numberOfWeeks})',
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedOverflowText(
                  text: '${criteria.regular}',
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedOverflowText(
                  text:
                      '${criteria.midtermSupervisor} + ${criteria.midtermPanel}',
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedOverflowText(
                  text:
                      '${criteria.endtermSupervisor} + ${criteria.endtermPanel}',
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedOverflowText(
                  text: '${criteria.report}',
                  color: Colors.black,
                ),
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
      widget.evaluationCriterias.sort(
        (criteria1, criteria2) => compareString(
            ascending,
            '${criteria1.weeksToConsider} (${criteria1.numberOfWeeks})',
            '${criteria2.weeksToConsider} (${criteria2.numberOfWeeks})'),
      );
    } else if (columnIndex == 1) {
      widget.evaluationCriterias.sort(
        (criteria1, criteria2) => compareString(ascending,
            criteria1.regular.toString(), criteria2.regular.toString()),
      );
    } else if (columnIndex == 2) {
      widget.evaluationCriterias.sort(
        (criteria1, criteria2) => compareString(
            ascending,
            '${criteria1.midtermSupervisor} + ${criteria1.midtermPanel}',
            '${criteria2.midtermSupervisor} + ${criteria2.midtermPanel}'),
      );
    } else if (columnIndex == 3) {
      widget.evaluationCriterias.sort(
        (criteria1, criteria2) => compareString(
            ascending,
            '${criteria1.endtermSupervisor} + ${criteria1.endtermPanel}',
            '${criteria2.endtermSupervisor} + ${criteria2.endtermPanel}'),
      );
    } else if (columnIndex == 4) {
      widget.evaluationCriterias.sort(
        (criteria1, criteria2) => compareString(ascending,
            criteria1.report.toString(), criteria2.report.toString()),
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
              ? -1
              : int.parse(value2) > int.parse(value1)
                  ? 1
                  : 0);
    }
    return (ascending ? value1.compareTo(value2) : value2.compareTo(value1));
  }
}
