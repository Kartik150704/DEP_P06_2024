import 'dart:html';

import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'confirm_action.dart';

class EnrollmentRequestDataTable extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final List<EnrollmentRequest> enrollments = [];
  EnrollmentRequestDataTable({super.key});

  @override
  State<EnrollmentRequestDataTable> createState() =>
      _EnrollmentRequestDataTableState();
}

class _EnrollmentRequestDataTableState
    extends State<EnrollmentRequestDataTable> {
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
    await FirebaseFirestore.instance
        .collection('enrollment_requests')
        .where('status', isEqualTo: '2')
        .get()
        .then((value) async {
      for (var doc in value.docs) {
        var len = widget.enrollments.length;
        // print(doc['offering_id']);
        await FirebaseFirestore.instance
            .collection('offerings')
            .get()
            .then((value) async {
          // print(value.docs.length);
          for (var doc1 in value.docs) {
            if (doc1.id != doc['offering_id']) {
              continue;
            }
            // print(FirebaseAuth.instance.currentUser!.uid);
            if (doc1['instructor_id'] ==
                FirebaseAuth.instance.currentUser!.uid) {
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
                      id: doc2['uid'],
                      name: doc2['name'],
                      email: doc2['email']);
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
                    team_id: doc['team_id']);
                widget.enrollments.add(enrollment);
              });
            }
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
      'Team ID',
      'Type',
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
                child: CustomisedText(
                  text: enrollment.offering.project.title,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 50,
                child: CustomisedOverflowText(
                  text: enrollment.team_id,
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
              Row(
                children: [
                  CustomisedButton(
                    text: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    height: 30,
                    width: 30,
                    onPressed: () => confirmAction(),
                    elevation: 0,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  CustomisedButton(
                    text: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    height: 30,
                    width: 30,
                    onPressed: () => confirmAction(),
                    elevation: 0,
                  ),
                ],
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
          panel1.team_id.toString(),
          panel2.team_id.toString(),
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
