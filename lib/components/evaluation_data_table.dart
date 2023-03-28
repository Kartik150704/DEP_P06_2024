import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/components/marks_submission_form.dart';
import 'package:casper/student/project_page.dart';
import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';

class EvaluationDataTable extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final evaluations;

  const EvaluationDataTable({
    super.key,
    required this.evaluations,
  });

  @override
  State<EvaluationDataTable> createState() => _EvaluationDataTableState();
}

class _EvaluationDataTableState extends State<EvaluationDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  void viewEvaluation(evaluation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: MarksSubmissionForm(
              evaluation: evaluation,
              onSubmit: () {},
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final columns = [
      'Week',
      'Date',
      'Marks',
      'Remarks',
      'Details',
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
        rows: getRows(widget.evaluations),
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
      ),
      DataColumn(
        label: CustomisedText(
          text: columns[4],
        ),
      ),
    ];

    return headings;
  }

  List<DataRow> getRows(List<Evaluation> rows) => rows.map(
        (Evaluation evaluation) {
          final cells = [
            DataCell(
              CustomisedText(
                text: evaluation.week,
                color: Colors.black,
              ),
            ),
            DataCell(
              CustomisedText(
                text: evaluation.date,
                color: Colors.black,
              ),
            ),
            DataCell(
              CustomisedText(
                text: evaluation.marks,
                color: Colors.black,
              ),
            ),
            DataCell(
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 150,
                ),
                child: SelectionArea(
                  child: Text(
                    evaluation.remarks,
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Ubuntu',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            DataCell(
              CustomisedButton(
                width: double.infinity,
                height: 35,
                text: 'View',
                onPressed: () => viewEvaluation(evaluation),
                elevation: 0,
              ),
            )
          ];

          return DataRow(
            cells: cells,
            color: MaterialStateProperty.resolveWith(
              (states) {
                if (evaluation.status == '1') {
                  return const Color.fromARGB(255, 208, 219, 144);
                } else if (evaluation.status == '2') {
                  return const Color(0xff7ae37b);
                }
                return const Color.fromARGB(255, 212, 203, 216);
              },
            ),
          );
        },
      ).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.evaluations.sort(
        (evaluation1, evaluation2) =>
            compareString(ascending, evaluation1.week, evaluation2.week),
      );
    } else if (columnIndex == 1) {
      widget.evaluations.sort(
        (evaluation1, evaluation2) =>
            compareString(ascending, evaluation1.date, evaluation2.date),
      );
    } else if (columnIndex == 2) {
      widget.evaluations.sort(
        (evaluation1, evaluation2) =>
            compareString(ascending, evaluation1.marks, evaluation2.marks),
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
