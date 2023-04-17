import 'package:casper/components/confirm_action.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EnrollmentRequestsDataTable extends StatefulWidget {
  final List<EnrollmentRequest> requests;

  const EnrollmentRequestsDataTable({
    super.key,
    required this.requests,
  });

  @override
  State<EnrollmentRequestsDataTable> createState() =>
      _EnrollmentRequestDataTableState();
}

class _EnrollmentRequestDataTableState
    extends State<EnrollmentRequestsDataTable> {
  var Team_names = {};
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

  void getTeams() async {
    setState(() {
      Team_names = {};
    });
    List<String> Team_ids = [];
    for (int i = 0; i < widget.requests.length; i++) {
      setState(() {
        Team_ids.add(widget.requests[i].teamId);
      });
    }
    if (!mounted) return;
    await FirebaseFirestore.instance
        .collection('team')
        .where('id', whereIn: Team_ids)
        .get()
        .then((value) async {
      for (var doc in value.docs) {
        List<String> temp = [];
        for (String stud in doc['students']) {
          if (!mounted) return;
          await FirebaseFirestore.instance
              .collection('student')
              .where('id', isEqualTo: stud)
              .get()
              .then((value) {
            for (var doc in value.docs) {
              if (!mounted) return;
              setState(() {
                temp.add(doc['name']);
              });
            }
          });
        }
        if (!mounted) return;
        setState(() {
          Team_names[doc['id']] = (temp);
        });
        print(Team_names[doc['id']]);
      }
    });
    // for (int i = 0; i < Team_names.length; i++) {
    //   print(Team_names[i]);
    // }
  }

  @override
  void initState() {
    super.initState();
    getTeams();
  }

  @override
  Widget build(BuildContext context) {
    final columns = [
      'Project',
      'Team',
      'Students',
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
      ),
      DataColumn(
        label: CustomisedText(
          text: columns[3],
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
                  text: request.offering.project.title,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 50,
                child: CustomisedOverflowText(
                  text: request.teamId,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 300,
                child: CustomisedOverflowText(
                  text:
                      '${Team_names[request.teamId][0]}, ${Team_names[request.teamId][1]}',
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              Row(
                children: [
                  CustomisedButton(
                    text: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    height: 30,
                    width: 30,
                    onPressed: () => confirmAction(),
                    elevation: 0,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  CustomisedButton(
                    text: const Icon(
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
      widget.requests.sort(
        (panel1, panel2) => compareString(
          ascending,
          panel1.offering.project.title.toString(),
          panel2.offering.project.title.toString(),
        ),
      );
    } else if (columnIndex == 1) {
      widget.requests.sort(
        (panel1, panel2) => compareString(
          ascending,
          panel1.teamId.toString(),
          panel2.teamId.toString(),
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
