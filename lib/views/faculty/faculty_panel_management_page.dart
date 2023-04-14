import 'package:casper/components/confirm_action.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/data_tables/faculty/panels_data_table.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/components/panel_forms/add_panel_from_CSV_form.dart';
import 'package:casper/models/models.dart';
import 'package:casper/seeds.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/panel_forms/assign_teams_to_panels_from_CSV_form.dart';

import '../../components/panel_forms/add_panel_form.dart';

class FacultyPanelManagementPage extends StatefulWidget {
  final String userRole;

  // ignore: prefer_typing_uninitialized_variables
  final viewPanel;

  const FacultyPanelManagementPage({
    Key? key,
    required this.userRole,
    required this.viewPanel,
  }) : super(key: key);

  @override
  State<FacultyPanelManagementPage> createState() =>
      _FacultyPanelManagementPageState();
}

class _FacultyPanelManagementPageState
    extends State<FacultyPanelManagementPage> {
  late List<AssignedPanel> assignedPanels = [];
  final panelIDController = TextEditingController(),
      evaluatorNameController = TextEditingController();

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

  // TODO: Implement this method
  void getPanels() {
    setState(() {
      assignedPanels.clear();
      // assignedPanels.add(assignedPanelsGLOBAL[0]);
      // assignedPanels = assignedPanelsGLOBAL;
    });
    FirebaseFirestore.instance.collection('assigned_panel').get().then((value) {
      for (var doc in value.docs) {
        // print(doc['assigned_project_ids'].runtimeType);
        setState(() {
          assignedPanels.add(
            AssignedPanel(
              id: doc['panel_id'],
              course: doc['course'],
              term: doc['term'],
              semester: doc['semester'],
              year: doc['year'],
              numberOfAssignedTeams: 0,
              panel: Panel(
                  course: doc['course'],
                  semester: doc['semester'],
                  year: doc['year'],
                  id: doc['panel_id'],
                  numberOfEvaluators: int.parse(doc['number_of_evaluators']),
                  evaluators: List<Faculty>.generate(
                      int.parse(doc['number_of_evaluators']),
                      (index) => Faculty(
                          id: doc['evaluator_ids'][index],
                          name: doc['evaluator_names'][index],
                          email: ''))),
              assignedTeams: [],
              evaluations: [],
              assignedProjectIds:
                  List<String>.from(doc['assigned_project_ids']),
              numberOfAssignedProjects:
                  int.tryParse(doc['number_of_assigned_projects']),
            ),
          );
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getPanels();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth * 0.97;
    final ScrollController scrollController = ScrollController();
    return Expanded(
      child: Scaffold(
        body: Container(
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
                          text: 'Panel Management',
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
                          width: 35 * fem,
                        ),
                        SearchTextField(
                          textEditingController: panelIDController,
                          hintText: 'Panel Identification',
                          width: 180 * fem,
                        ),
                        SizedBox(
                          width: 20 * fem,
                        ),
                        SearchTextField(
                          textEditingController: evaluatorNameController,
                          hintText: 'Evaluator\'s Name',
                          width: 180 * fem,
                        ),
                        SizedBox(
                          width: 25 * fem,
                        ),
                        SizedBox(
                          height: 47,
                          width: 47,
                          child: FloatingActionButton(
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 212, 203, 216),
                            splashColor: Colors.black,
                            hoverColor: Colors.grey,
                            child: const Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 29,
                            ),
                            onPressed: () {},
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
                        child: Scrollbar(
                          controller: scrollController,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: scrollController,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: PanelsDataTable(
                                assignedPanels: assignedPanels,
                                viewPanel: widget.viewPanel,
                              ),
                            ),
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
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 7, 0),
              child: Tooltip(
                message: 'Create Panel(s)',
                child: FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 212, 203, 216),
                  splashColor: Colors.black,
                  hoverColor: Colors.grey,
                  child: const Icon(
                    Icons.upload_file,
                    color: Colors.black,
                    size: 35,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Center(
                            child: CreatePanelFromCSVForm(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 7, 0),
              child: Tooltip(
                message: 'Assign Teams to Panel(s)',
                child: FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 212, 203, 216),
                  splashColor: Colors.black,
                  hoverColor: Colors.grey,
                  child: const Icon(
                    Icons.upload_file,
                    color: Colors.black,
                    size: 35,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Center(
                            child: AssignTeamsToPanelsFromCSVForm(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 7, 0),
              child: Tooltip(
                message: 'Add Panel',
                child: FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 212, 203, 216),
                  splashColor: Colors.black,
                  hoverColor: Colors.grey,
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 35,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Center(
                            child: AddPanelForm(
                              refresh: getPanels,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 65,
            ),
          ],
        ),
      ),
    );
  }
}
