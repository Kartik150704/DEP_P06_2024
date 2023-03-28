import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/faculty/loggedinscaffoldFaculty.dart';
import 'package:casper/components/marks_submission_form.dart';
import 'package:casper/student/project_page.dart';
import 'package:casper/utilites.dart';
import 'package:casper/faculty/enrollmentsPageFaculty.dart';
import 'package:flutter/material.dart';

class EnrollmentDataTable extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final enrollments;
  final String role;

  const EnrollmentDataTable({
    super.key,
    required this.enrollments,
    required this.role,
  });

  @override
  State<EnrollmentDataTable> createState() => _EnrollmentDataTableState();
}

class _EnrollmentDataTableState extends State<EnrollmentDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  Widget build(BuildContext context) {
    final columns = [
      'Name',
      'Student Name(s)',
      'Semester',
      'Year',
      'Project Description',
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
        rows: getRows(widget.enrollments),
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

  List<DataRow> getRows(List<Enrollment> rows) => rows.map(
        (Enrollment enrollment) {
          final cells = [
            DataCell(
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoggedInScaffoldFaculty(
                          role: widget.role,
                          scaffoldbody: Row(
                            children: [
                              ProjectPage(
                                project_id: enrollment.project_id,
                                project: const [
                                  '',
                                  '',
                                  '',
                                  '',
                                  ['', '']
                                ],
                              )
                            ],
                          )),
                    ),
                  );
                },
                child: CustomisedText(
                  text: enrollment.name,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              CustomisedText(
                text: enrollment.sname,
                color: Colors.black,
              ),
            ),
            DataCell(
              CustomisedText(
                text: enrollment.sem,
                color: Colors.black,
              ),
            ),
            DataCell(
              CustomisedText(
                text: enrollment.year,
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
                    enrollment.description,
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
          ];

          return DataRow(
              cells: cells,
              color: MaterialStateProperty.all(
                  Color.fromARGB(255, 212, 203, 216)));
        },
      ).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.enrollments.sort(
        (enrollment1, enrollment2) =>
            compareString(ascending, enrollment1.name, enrollment2.name),
      );
    } else if (columnIndex == 1) {
      widget.enrollments.sort(
        (enrollment1, enrollment2) =>
            compareString(ascending, enrollment1.date, enrollment2.date),
      );
    } else if (columnIndex == 2) {
      widget.enrollments.sort(
        (enrollment1, enrollment2) =>
            compareString(ascending, enrollment1.marks, enrollment2.marks),
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
