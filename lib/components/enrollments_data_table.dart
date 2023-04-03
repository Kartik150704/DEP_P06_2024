import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/models.dart';
import 'package:casper/seeds.dart';
import 'package:flutter/material.dart';

class EnrollmentsDataTable extends StatefulWidget {
  final List<Enrollment> enrollments;
  final String userRole;
  // ignore: prefer_typing_uninitialized_variables
  final showProject;

  const EnrollmentsDataTable({
    super.key,
    required this.enrollments,
    required this.userRole,
    required this.showProject,
  });

  @override
  State<EnrollmentsDataTable> createState() => _EnrollmentsDataTableState();
}

class _EnrollmentsDataTableState extends State<EnrollmentsDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  final int totalWeekly = evaluationCriteriasGLOBAL[0].regular,
      totalMidterm = evaluationCriteriasGLOBAL[0].midtermSupervisor,
      totalEndterm = evaluationCriteriasGLOBAL[0].endtermSupervisor,
      totalReport = evaluationCriteriasGLOBAL[0].report;
  late List<StudentData> studentData = [];

  void getStudentData() {
    setState(() {
      studentData = [];
    });

    for (final enrollment in widget.enrollments) {
      for (final student in enrollment.team.students) {
        int weekly = -1, weekCount = 0, midterm = -1, endterm = -1, report = -1;
        String grade = 'NA';
        for (final evaluation in enrollment.supervisorEvaluations) {
          if (evaluation.student.id == student.id) {
            if (evaluation.type == 'midterm-supervisor') {
              midterm = evaluation.marks;
            } else if (evaluation.type == 'endterm-suerpvisor') {
              endterm = evaluation.marks;
            } else if (evaluation.type.contains('week')) {
              weekCount += 1;
              if (weekly == -1) {
                weekly = evaluation.marks;
              } else {
                weekly += evaluation.marks;
              }
            } else if (evaluation.type == 'report') {
              report = evaluation.marks;
            } else if (evaluation.type.contains('grade')) {
              grade = evaluation.type.split('_')[1];
            }
          }
        }

        studentData.add(
          StudentData(
            weekly: (weekCount == 0 ? -1 : (weekly / weekCount).round()),
            midterm: midterm,
            endterm: endterm,
            report: report,
            grade: grade,
            projectId: enrollment.offering.project.id,
            projectTitle: enrollment.offering.project.title,
            teamId: enrollment.team.id,
            type:
                '${enrollment.offering.course}-${enrollment.offering.year}-${enrollment.offering.semester}',
            student: student,
          ),
        );
      }
    }
  }

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
    } else if (studentData.isEmpty) {
      getStudentData();
    }

    final columns = [
      'Project',
      'Team',
      'Student',
      'Type',
      'W($totalWeekly)',
      'M',
      'E',
      'R',
      'G',
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
      DataColumn(
        label: CustomisedText(
          text: columns[7],
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: CustomisedText(
          text: columns[8],
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
              Container(
                width: 160,
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => widget.showProject(
                    data.projectId,
                  ),
                  child: CustomisedOverflowText(
                    text: data.projectTitle,
                    color: Colors.blue[900],
                    selectable: false,
                  ),
                ),
              ),
            ),
            DataCell(
              CustomisedText(
                text: data.teamId.toString(),
                color: Colors.black,
              ),
            ),
            DataCell(
              SizedBox(
                width: 140,
                child: CustomisedOverflowText(
                  text: data.student.name,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedText(
                  text: data.type,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              CustomisedText(
                text: (data.weekly == -1 ? 'NA' : '${data.weekly}'),
                color: Colors.black,
              ),
            ),
            DataCell(
              CustomisedText(
                text: (data.midterm == -1
                    ? 'NA'
                    : '${data.midterm}/$totalMidterm'),
                color: Colors.black,
              ),
            ),
            DataCell(
              CustomisedText(
                text: (data.endterm == -1
                    ? 'NA'
                    : '${data.endterm}/$totalEndterm'),
                color: Colors.black,
              ),
            ),
            DataCell(
              CustomisedText(
                text:
                    (data.report == -1 ? 'NA' : '${data.report}/$totalReport'),
                color: Colors.black,
              ),
            ),
            DataCell(
              CustomisedText(
                text: data.grade,
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
      studentData.sort(
        (data1, data2) =>
            compareString(ascending, data1.projectTitle, data2.projectTitle),
      );
    } else if (columnIndex == 1) {
      studentData.sort(
        (data1, data2) => compareString(ascending, data1.teamId, data2.teamId),
      );
    } else if (columnIndex == 2) {
      studentData.sort(
        (data1, data2) =>
            compareString(ascending, data1.student.name, data2.student.name),
      );
    } else if (columnIndex == 3) {
      studentData.sort(
        (data1, data2) => compareString(ascending, data1.type, data2.type),
      );
    } else if (columnIndex == 4) {
      studentData.sort(
        (data1, data2) => compareString(
            ascending, data1.weekly.toString(), data2.weekly.toString()),
      );
    } else if (columnIndex == 5) {
      studentData.sort(
        (data1, data2) => compareString(
            ascending, data1.midterm.toString(), data2.midterm.toString()),
      );
    } else if (columnIndex == 6) {
      studentData.sort(
        (data1, data2) => compareString(
            ascending, data1.endterm.toString(), data2.endterm.toString()),
      );
    } else if (columnIndex == 7) {
      studentData.sort(
        (data1, data2) => compareString(
            ascending, data1.report.toString(), data2.report.toString()),
      );
    } else if (columnIndex == 8) {
      studentData.sort(
        (data1, data2) => compareString(ascending, data1.grade, data2.grade),
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
  final int weekly, midterm, endterm, report;
  final String projectTitle, teamId, projectId, type, grade;
  final Student student;

  StudentData({
    required this.weekly,
    required this.midterm,
    required this.endterm,
    required this.report,
    required this.grade,
    required this.projectTitle,
    required this.teamId,
    required this.projectId,
    required this.type,
    required this.student,
  });
}
