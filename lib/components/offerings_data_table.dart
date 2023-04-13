import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OfferingsDataTable extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final List<Offering> offerings = [];
  OfferingsDataTable({super.key});

  @override
  State<OfferingsDataTable> createState() => _OfferingsDataTableState();
}

class _OfferingsDataTableState extends State<OfferingsDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  void fill() {
    FirebaseFirestore.instance
        .collection('offerings')
        .get()
        .then((value) async {
      for (var doc in value.docs) {
        var len = widget.offerings.length;
        Project project = Project(
            id: doc.id, title: doc['title'], description: doc['description']);
        Faculty faculty = Faculty(id: '', name: '', email: '');
        await FirebaseFirestore.instance
            .collection('instructors')
            .where('uid', isEqualTo: doc['instructor_id'])
            .get()
            .then((value) {
          for (var doc1 in value.docs) {
            faculty = Faculty(
                id: doc1['uid'], name: doc1['name'], email: doc1['email']);
          }
        });
        setState(() {
          Offering offering = Offering(
              id: (len + 1).toString(),
              project: project,
              instructor: faculty,
              semester: doc['semester'],
              year: doc['year'],
              course: doc['type']);
          widget.offerings.add(offering);
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
      'ID',
      'Title',
      'Supervisor',
      'Type',
      'View Details',
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
      DataColumn(
        label: CustomisedText(
          text: columns[4],
        ),
      ),
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
              SizedBox(
                child: CustomisedText(
                  text: offerings.project.title,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 200,
                child: CustomisedOverflowText(
                  text: offerings.instructor.name,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              CustomisedOverflowText(
                text:
                    '${offerings.course}-${offerings.year}-${offerings.semester}',
                color: Colors.black,
              ),
            ),
            DataCell(
              CustomisedButton(
                text: const Icon(
                  Icons.open_in_new_rounded,
                  size: 20,
                ),
                height: 37,
                width: double.infinity,
                onPressed: () => {},
                elevation: 0,
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

  int compareString(bool ascending, String value1, String value2) =>
      (ascending ? value1.compareTo(value2) : value2.compareTo(value1));
}
