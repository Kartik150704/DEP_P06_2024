import 'package:casper/components/customised_button.dart';
import 'package:casper/comp/customised_overflow_text.dart';
import 'package:casper/comp/customised_text.dart';
import 'package:casper/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OfferedProjectsDataTable extends StatefulWidget {
  bool isStudent;
  List<Offering> offerings;

  // ignore: prefer_typing_uninitialized_variables
  var refresh;

  OfferedProjectsDataTable({
    super.key,
    required this.isStudent,
    required this.offerings,
    required this.refresh,
  });

  @override
  State<OfferedProjectsDataTable> createState() =>
      _OfferedProjectsDataTableState();
}

class _OfferedProjectsDataTableState extends State<OfferedProjectsDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.offerings.isEmpty) {
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
                text: 'No projects found',
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
      'Project',
      'Supervisor',
      'Course',
    ];

    if (widget.isStudent) {
      columns.add('Action');
    }

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
        rows: getRows(widget.offerings),
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
      if (widget.isStudent) ...[
        DataColumn(
          label: CustomisedText(
            text: columns[4],
          ),
        ),
      ]
    ];

    return headings;
  }

  List<DataRow> getRows(List<Offering> rows) => rows.map(
        (Offering offerings) {
          final cells = [
            DataCell(
              SizedBox(
                child: CustomisedText(
                  text: offerings.id,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              Tooltip(
                message:
                    '${offerings.project.title} - ${offerings.project.description}',
                child: SizedBox(
                  width: 300,
                  child: CustomisedOverflowText(
                    text: offerings.project.title,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            DataCell(
              Tooltip(
                message: offerings.instructor.name,
                child: SizedBox(
                  width: 150,
                  child: CustomisedOverflowText(
                    text: offerings.instructor.name,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            DataCell(
              CustomisedOverflowText(
                text: offerings.course,
                color: Colors.black,
              ),
            ),
            if (widget.isStudent) ...[
              DataCell(
                CustomisedButton(
                  text: 'Request',
                  height: 37,
                  width: double.infinity,
                  onPressed: () {
                    // ensure not already requested
                    FirebaseFirestore.instance
                        .collection('student')
                        .where('uid',
                            isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .get()
                        .then((value) {
                      var doc = value.docs[0];
                      String studendId = doc['id'];
                      FirebaseFirestore.instance
                          .collection('team')
                          .get()
                          .then((teamdocs) {
                        String? teamId;
                        for (var teamdoc in teamdocs.docs) {
                          if (teamdoc['students'].contains(studendId)) {
                            teamId = teamdoc['id'];
                            break;
                          }
                        }
                        if (teamId != null) {
                          FirebaseFirestore.instance
                              .collection('enrollment_requests')
                              .where('team_id', isEqualTo: teamId)
                              .where('offering_id', isEqualTo: offerings.key_id)
                              .get()
                              .then((requestDocs) {
                            if (requestDocs.docs.length == 0) {
                              FirebaseFirestore.instance
                                  .collection('enrollment_requests')
                                  .add({
                                'team_id': teamId,
                                'offering_id': offerings.key_id,
                                'status': '2',
                              }).then((value) => widget.refresh());
                            }
                          });
                        }
                      });
                    });
                    // if not, request
                  },
                  elevation: 0,
                ),
              ),
            ],
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
      widget.offerings.sort(
        (panel1, panel2) => compareString(
          ascending,
          panel1.id.toString(),
          panel2.id.toString(),
        ),
      );
    } else if (columnIndex == 1) {
      widget.offerings.sort(
        (panel1, panel2) => compareString(
          ascending,
          panel1.project.title.toString(),
          panel2.project.title.toString(),
        ),
      );
    } else if (columnIndex == 2) {
      widget.offerings.sort(
        (panel1, panel2) => compareString(
          ascending,
          panel1.instructor.name.toString(),
          panel2.instructor.name.toString(),
        ),
      );
    } else if (columnIndex == 3) {
      widget.offerings.sort(
        (panel1, panel2) => compareString(
          ascending,
          panel1.course.toString(),
          panel2.course.toString(),
        ),
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
              ? 1
              : int.parse(value2) > int.parse(value1)
                  ? -1
                  : 0);
    }
    return (ascending ? value1.compareTo(value2) : value2.compareTo(value1));
  }
}
