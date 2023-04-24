import 'package:casper/comp/data_not_found.dart';
import 'package:casper/components/confirm_action.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/models/models.dart';
import 'package:flutter/material.dart';

class StudentEnrollmentRequestsDataTable extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final List<EnrollmentRequest> requests;

  const StudentEnrollmentRequestsDataTable({
    super.key,
    required this.requests,
  });

  @override
  State<StudentEnrollmentRequestsDataTable> createState() =>
      _StudentEnrollmentRequestsDataTableState();
}

class _StudentEnrollmentRequestsDataTableState
    extends State<StudentEnrollmentRequestsDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  void confirmAction() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: ConfirmAction(
              onSubmit: () {},
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.requests.isEmpty) {
      return DataNotFound(message: 'No Requests Found');
    }

    final columns = [
      'ID',
      'Project',
      'Instructor',
      'Type',
      'Status',
      'Action',
    ];

    return Theme(
      data: Theme.of(context).copyWith(
          iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white)),
      child: DataTable(
        dataRowHeight: 50,
        border: TableBorder.all(
          width: 2,
          borderRadius: BorderRadius.circular(2),
          color: const Color.fromARGB(255, 43, 40, 40),
        ),
        sortAscending: isAscending,
        sortColumnIndex: sortColumnIndex,
        columns: getColumns(columns),
        rows: getRows(widget.requests),
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
      DataColumn(
        label: CustomisedText(
          text: columns[5],
        ),
      ),
    ];

    return headings;
  }

  List<DataRow> getRows(List<EnrollmentRequest> rows) => rows.map(
        (EnrollmentRequest request) {
          final cells = [
            DataCell(
              SizedBox(
                child: CustomisedText(
                  text: request.id,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedOverflowText(
                  text: request.offering.project.title,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedText(
                  text: request.offering.instructor.name,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              CustomisedOverflowText(
                text:
                    '${request.offering.course}-${request.offering.year}-${request.offering.semester}',
                color: Colors.black,
              ),
            ),
            DataCell(
              CustomisedOverflowText(
                text: (request.status == '0')
                    ? 'Rejected'
                    : (request.status == '1')
                        ? 'Accepted'
                        : 'Pending',
                color: Colors.black,
              ),
            ),
            DataCell(
              (request.status != '0'
                  ? (request.status == '1'
                      ? const CustomisedText(
                          text: 'Accepted',
                          color: Colors.black,
                        )
                      : CustomisedButton(
                          width: double.infinity,
                          height: 35,
                          text: 'Withdraw',
                          onPressed: () {},
                          elevation: 0,
                        ))
                  : const CustomisedText(
                      text: 'Rejected',
                      color: Colors.black,
                    )),
            ),
          ];

          return DataRow(
            cells: cells,
            color: MaterialStateProperty.resolveWith(
              (states) {
                if (request.status == '0') {
                  return const Color.fromARGB(255, 223, 104, 104);
                } else if (request.status == '1') {
                  return const Color(0xff7ae37b);
                } else {
                  return const Color.fromARGB(255, 208, 219, 144);
                }
              },
            ),
          );
        },
      ).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.requests.sort(
        (request1, request2) => compareString(
          ascending,
          request1.id,
          request2.id,
        ),
      );
    } else if (columnIndex == 1) {
      widget.requests.sort(
        (request1, request2) => compareString(
          ascending,
          request1.offering.project.title,
          request2.offering.project.title,
        ),
      );
    } else if (columnIndex == 2) {
      widget.requests.sort(
        (request1, request2) => compareString(
          ascending,
          request1.offering.instructor.name,
          request2.offering.instructor.name,
        ),
      );
    } else if (columnIndex == 3) {
      widget.requests.sort(
        (request1, request2) => compareString(
          ascending,
          '${request1.offering.course}-${request1.offering.year}-${request1.offering.semester}',
          '${request2.offering.course}-${request2.offering.year}-${request2.offering.semester}',
        ),
      );
    } else if (columnIndex == 4) {
      widget.requests.sort(
        (request1, request2) => compareString(
          ascending,
          request1.status,
          request2.status,
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
