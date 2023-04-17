import 'dart:html';

import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/confirm_action.dart';

class StudentRequestDataTable extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final List<EnrollmentRequest> enrollments = [];
  StudentRequestDataTable({super.key});

  @override
  State<StudentRequestDataTable> createState() =>
      _StudentRequestDataTableState();
}

class _StudentRequestDataTableState extends State<StudentRequestDataTable> {
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

  void fill() async {
    String entry = '';
    await FirebaseFirestore.instance
        .collection('student')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        entry = doc['id'];
      }
    });
    String team_id = '';
    await FirebaseFirestore.instance.collection('team').get().then((value) {
      for (var doc in value.docs) {
        for (String entry1 in doc['students']) {
          if (entry1 == entry) {
            team_id = doc['id'];
          }
        }
      }
    });
    await FirebaseFirestore.instance
        .collection('enrollment_requests')
        .where('team_id', isEqualTo: team_id)
        .get()
        .then((value) async {
      for (var doc in value.docs) {
        var len = widget.enrollments.length;
        await FirebaseFirestore.instance
            .collection('offerings')
            .get()
            .then((value) async {
          for (var doc1 in value.docs) {
            if (doc1.id != doc['offering_id']) {
              continue;
            }
            Project project = Project(
                id: doc1.id,
                title: doc1['title'],
                description: doc1['description']);
            Faculty faculty = Faculty(id: '', name: '', email: '');
            await FirebaseFirestore.instance
                .collection('instructors')
                .where('uid', isEqualTo: doc1['instructor_id'])
                .get()
                .then((value) {
              for (var doc2 in value.docs) {
                faculty = Faculty(
                    id: doc2['uid'], name: doc2['name'], email: doc2['email']);
              }
            });
            setState(() {
              Offering offering = Offering(
                  id: (len + 1).toString(),
                  project: project,
                  instructor: faculty,
                  semester: doc1['semester'],
                  year: doc1['year'],
                  course: doc1['type']);
              EnrollmentRequest enrollment = EnrollmentRequest(
                  id: (len + 1).toString(),
                  status: doc['status'],
                  offering: offering,
                  teamId: doc['team_id']);
              widget.enrollments.add(enrollment);
            });
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fill();
  }

  @override
  Widget build(BuildContext context) {
    final columns = [
      'Sr No.',
      'Title',
      'Supervisor Name',
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
        onSort: onSort,
      ),
      DataColumn(
        label: CustomisedText(
          text: columns[4],
        ),
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
        (EnrollmentRequest enrollment) {
          final cells = [
            DataCell(
              SizedBox(
                child: CustomisedText(
                  text: enrollment.id,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedOverflowText(
                  text: enrollment.offering.project.title,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedText(
                  text: enrollment.offering.instructor.name,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              CustomisedOverflowText(
                text:
                    '${enrollment.offering.course}-${enrollment.offering.year}-${enrollment.offering.semester}',
                color: Colors.black,
              ),
            ),
            DataCell(
              CustomisedOverflowText(
                text: (enrollment.status == '0')
                    ? 'Rejected'
                    : (enrollment.status == '1')
                        ? 'Accepted'
                        : 'Pending',
                color: Colors.black,
              ),
            ),
            DataCell(
              CustomisedButton(
                text: (enrollment.status == '0')
                    ? 'Rejected'
                    : (enrollment.status == '1')
                        ? 'Accepted'
                        : 'Withdraw',
                onPressed: () =>
                    (enrollment.status == '2') ? confirmAction() : {},
                width: 100,
                height: 30,
              ),
            ),
          ];

          return DataRow(
            cells: cells,
            color: MaterialStateProperty.resolveWith(
              (states) {
                if (enrollment.status == '0') {
                  return Color.fromARGB(255, 184, 7, 7);
                } else if (enrollment.status == '1') {
                  return const Color(0xff7ae37b);
                } else {
                  return const Color.fromARGB(255, 212, 203, 216);
                }
              },
            ),
          );
        },
      ).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.enrollments.sort(
        (panel1, panel2) => compareString(
          ascending,
          panel1.id.toString(),
          panel2.id.toString(),
        ),
      );
    } else if (columnIndex == 1) {
      widget.enrollments.sort(
        (panel1, panel2) => compareString(
          ascending,
          panel1.offering.project.title.toString(),
          panel2.offering.project.title.toString(),
        ),
      );
    } else if (columnIndex == 2) {
      widget.enrollments.sort(
        (panel1, panel2) => compareString(
          ascending,
          panel1.teamId.toString(),
          panel2.teamId.toString(),
        ),
      );
    } else if (columnIndex == 3) {
      widget.enrollments.sort(
        (panel1, panel2) => compareString(
          ascending,
          panel1.offering.course.toString(),
          panel2.offering.course.toString(),
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
