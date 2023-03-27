import 'package:casper/components/customised_text.dart';
import 'package:casper/components/evaluation_tile.dart';
import 'package:casper/student/no_projects_found_page.dart';
import 'package:flutter/material.dart';

class ProjectPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final project;

  const ProjectPage({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  var evaluationDetails = [
    [
      '1',
      'Week 4',
      ['NA', 'NA'],
    ],
    [
      '1',
      'Week 3',
      ['NA', 'NA'],
    ],
    [
      '2',
      'Week 2',
      ['97/100', 'Good work'],
    ],
    [
      '2',
      'Week 1',
      ['97/100', 'Good work'],
    ],
  ];

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = (MediaQuery.of(context).size.width / baseWidth) * 0.97;

    if (widget.project == null) {
      return const NoProjectsFoundPage();
    } else {
      return Expanded(
        child: Container(
          color: const Color(0xff302c42),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(60, 30, 100 * fem, 0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomisedText(
                      text: widget.project[0],
                      fontSize: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: CustomisedText(
                            text: widget.project[1] +
                                ' - ' +
                                widget.project[2] +
                                ' ' +
                                widget.project[3],
                            fontSize: 25,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomisedText(
                              text: widget.project[4][0],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomisedText(
                              text: widget.project[4][1],
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 670,
                      width: 1200 * fem,
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 75),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                          ),
                          BoxShadow(
                            color: Color.fromARGB(255, 70, 67, 83),
                            // color: Colors.white,
                            // spreadRadius: -3,
                            // blurRadius: 7,
                          ),
                        ],
                      ),
                      // child: SingleChildScrollView(
                      //   child: Container(
                      //     margin: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         for (int i = 0;
                      //             i < evaluationDetails.length;
                      //             i++) ...[
                      //           EvaluationTile(
                      //             status: evaluationDetails[i][0],
                      //             week: evaluationDetails[i][1],
                      //             details: evaluationDetails[i][2],
                      //           ),
                      //           const SizedBox(
                      //             height: 20,
                      //           ),
                      //         ],
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      //
                      //
                      //
                      child: buildDataTable(context),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  int? sortColumnIndex;
  bool isAscending = false;
  var users = [
    ['Aman', 'Kumar', '19', 'Female', 'true'],
    ['Aman', 'Adatia', '21', 'Male'],
    ['XYZ', 'ABC', '20', 'NA'],
  ];
  Widget buildDataTable(BuildContext context) {
    var columns = ['First Name', 'Last Name', 'Age', 'Gender'];

    return Theme(
      data: Theme.of(context).copyWith(
          iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white)),
      child: DataTable(
        dataRowColor: MaterialStateProperty.resolveWith(getDataRowColor),
        border: TableBorder.all(
          width: 0.5,
          borderRadius: BorderRadius.circular(2),
          color: Colors.grey,
        ),
        sortAscending: isAscending,
        sortColumnIndex: sortColumnIndex,
        columns: getColumns(columns),
        rows: getRows(users),
        headingRowColor: MaterialStateColor.resolveWith(
          (states) {
            return const Color(0xff12141D);
          },
        ),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map(
        (String column) => DataColumn(
          label: CustomisedText(text: column),
          onSort: onSort,
        ),
      )
      .toList();

  List<DataRow> getRows(List<List<String>> rows) => rows.map(
        (List<String> user) {
          var cells = [user[0], user[1], user[2], user[3]];

          return DataRow(cells: getCells(cells));
        },
      ).toList();

  List<DataCell> getCells(List<dynamic> cells) => cells
      .map(
        (data) => DataCell(
          CustomisedText(
            text: data,
            color: Colors.black,
          ),
        ),
      )
      .toList();

  void onSort(int columnIndex, bool ascending) {
    users.sort((user1, user2) =>
        compareString(ascending, user1[columnIndex], user2[columnIndex]));

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      (ascending ? value1.compareTo(value2) : value2.compareTo(value1));

  Color? getDataRowColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return Colors.black;
      // return Theme.of(context).colorScheme.primary.withOpacity(0.08);
    }
    return const Color.fromARGB(255, 227, 224, 230);
  }
}
