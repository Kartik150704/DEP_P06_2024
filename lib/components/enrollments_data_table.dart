import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/faculty/faculty_enrollments_page.dart';
import 'package:flutter/material.dart';

class EnrollmentsDataTable extends StatefulWidget {
  final List<Enrollment> enrollments;
  final String role;
  final showProject;

  const EnrollmentsDataTable({
    super.key,
    required this.enrollments,
    required this.role,
    required this.showProject,
  });

  @override
  State<EnrollmentsDataTable> createState() => _EnrollmentsDataTableState();
}

class _EnrollmentsDataTableState extends State<EnrollmentsDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  Widget build(BuildContext context) {
    if (widget.enrollments.isEmpty) {
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
                text: 'No Enrollments found',
                color: Colors.grey[300],
                fontSize: 30,
              ),
            ],
          ),
        ),
      );
    }

    final columns = [
      'Project Title',
      'Student(s)',
      'Course Code',
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

  List<DataRow> getRows(List<Enrollment> rows) => rows.map(
        (Enrollment enrollment) {
          final cells = [
            DataCell(
              Container(
                width: 250,
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => widget.showProject(enrollment.projectId),
                  child: CustomisedOverflowText(
                    text: enrollment.title,
                    color: Colors.blue[900],
                    selectable: false,
                  ),
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 300,
                child: CustomisedOverflowText(
                  text: enrollment.students,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              CustomisedText(
                text: enrollment.courseCode,
                color: Colors.black,
              ),
            ),
            DataCell(
              CustomisedText(
                text: enrollment.semester,
                color: Colors.black,
              ),
            ),
            DataCell(
              CustomisedText(
                text: enrollment.year,
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
      widget.enrollments.sort(
        (enrollment1, enrollment2) =>
            compareString(ascending, enrollment1.title, enrollment2.title),
      );
    } else if (columnIndex == 1) {
      widget.enrollments.sort(
        (enrollment1, enrollment2) => compareString(
            ascending, enrollment1.students, enrollment2.students),
      );
    } else if (columnIndex == 2) {
      widget.enrollments.sort(
        (enrollment1, enrollment2) => compareString(
            ascending, enrollment1.courseCode, enrollment2.courseCode),
      );
    } else if (columnIndex == 3) {
      widget.enrollments.sort(
        (enrollment1, enrollment2) => compareString(
            ascending, enrollment1.semester, enrollment2.semester),
      );
    } else if (columnIndex == 4) {
      widget.enrollments.sort(
        (enrollment1, enrollment2) =>
            compareString(ascending, enrollment1.year, enrollment2.year),
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
