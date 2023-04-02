import 'package:casper/components/button.dart';
import 'package:casper/components/confirm_action.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/components/assigned_panels_data_table.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/faculty/panelPage.dart';
import 'package:flutter/material.dart';

import '../components/projecttile.dart';
import '../utilites.dart';

class FacultyPanelsPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final role;

  const FacultyPanelsPage({
    Key? key,
    required this.role,
  }) : super(key: key);

  @override
  State<FacultyPanelsPage> createState() => _FacultyPanelsPageState();
}

class _FacultyPanelsPageState extends State<FacultyPanelsPage> {
  late List<AssignedPanel> panels = [];
  final panelNumberController = TextEditingController(),
      evaluatorNameController = TextEditingController(),
      panelTypeController = TextEditingController(),
      semesterController = TextEditingController(),
      yearController = TextEditingController();

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

  // TODO: Implement these methods
  void getSupervisorPanels() {
    panels = [
      AssignedPanel(
        number: '1',
        evaluators: 'Shweta Jain, Sudarshan Iyengar',
        teamsAssigned: '3',
        teamsEvaluated: '1',
        type: 'Mid-Term',
        semester: '2',
        year: '2022',
      )
    ];
  }

  void getAllPanels() {
    panels = [
      AssignedPanel(
        number: '1',
        evaluators: 'Shweta Jain, Sudarshan Iyengar',
        teamsAssigned: '3',
        teamsEvaluated: '1',
        type: 'Mid-Term',
        semester: '2',
        year: '2022',
      )
    ];
  }

  @override
  void initState() {
    super.initState();
    if (widget.role == 'su') {
      getSupervisorPanels();
    } else {
      getAllPanels();
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Expanded(
      child: Container(
        color: const Color(0xff302c42),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(60, 30, 0, 0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomisedText(
                        text: 'My Panels',
                        fontSize: 50,
                      ),
                      Container(),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 33 * fem,
                      ),
                      SearchTextField(
                        textEditingController: panelNumberController,
                        hintText: 'Panel Number',
                        width: 170 * fem,
                      ),
                      SizedBox(
                        width: 20 * fem,
                      ),
                      SearchTextField(
                        textEditingController: evaluatorNameController,
                        hintText: 'Evaluator Name',
                        width: 170 * fem,
                      ),
                      SizedBox(
                        width: 20 * fem,
                      ),
                      SearchTextField(
                        textEditingController: panelTypeController,
                        hintText: 'Panel Type',
                        width: 170 * fem,
                      ),
                      SizedBox(
                        width: 20 * fem,
                      ),
                      SearchTextField(
                        textEditingController: semesterController,
                        hintText: 'Semester',
                        width: 170 * fem,
                      ),
                      SizedBox(
                        width: 20 * fem,
                      ),
                      SearchTextField(
                        textEditingController: yearController,
                        hintText: 'Year',
                        width: 170 * fem,
                      ),
                      SizedBox(
                        width: 25 * fem,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[300],
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search,
                          ),
                          iconSize: 25,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1200 * fem,
                    height: 675,
                    margin: EdgeInsets.fromLTRB(40, 15, 80 * fem, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                        ),
                        BoxShadow(
                          color: Color.fromARGB(255, 70, 67, 83),
                          spreadRadius: -3,
                          blurRadius: 7,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: AssignedPanelsDataTable(
                          panels: panels,
                          role: widget.role,
                        ),
                      ),
                    ),
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

class AssignedPanel {
  final String number,
      evaluators,
      teamsAssigned,
      teamsEvaluated,
      type,
      semester,
      year;

  AssignedPanel({
    required this.number,
    required this.evaluators,
    required this.teamsAssigned,
    required this.teamsEvaluated,
    required this.type,
    required this.semester,
    required this.year,
  });
}
