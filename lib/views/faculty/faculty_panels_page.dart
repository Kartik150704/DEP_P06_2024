import 'package:casper/data_tables/faculty/assigned_panels_data_table.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/models/models.dart';
import 'package:casper/seeds.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FacultyPanelsPage extends StatefulWidget {
  final String userRole;

  // ignore: prefer_typing_uninitialized_variables
  final viewPanel;

  const FacultyPanelsPage({
    Key? key,
    required this.userRole,
    required this.viewPanel,
  }) : super(key: key);

  @override
  State<FacultyPanelsPage> createState() => _FacultyPanelsPageState();
}

class _FacultyPanelsPageState extends State<FacultyPanelsPage> {
  late List<AssignedPanel> assignedPanels = [];
  final panelIdController = TextEditingController(),
      evaluatorNameController = TextEditingController();

  // TODO: Implement this method
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('instructors')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      var doc = value.docs[0];
      List<String> panelids = List<String>.from(doc['panel_ids']);
      FirebaseFirestore.instance
          .collection('panels')
          .where('panel_id', whereIn: panelids)
          .get()
          .then((value) {
        for (var doc in value.docs) {
          // print(doc['assigned_project_ids'].runtimeType);
          setState(() {
            assignedPanels.add(AssignedPanel(
                id: doc['panel_id'],
                course: 'CP302',
                term: 'MidTerm',
                semester: '2',
                year: '2023',
                numberOfAssignedTeams: 0,
                panel: Panel(
                    course: 'CP302',
                    semester: '2',
                    year: '2023',
                    id: doc['panel_id'],
                    numberOfEvaluators: int.parse(doc['number_of_evaluators']),
                    evaluators: List<Faculty>.generate(
                        int.parse(doc['number_of_evaluators']),
                        (index) => Faculty(
                            id: doc['evaluator_ids'][index],
                            name: doc['evaluator_names'][index],
                            email: ''))),
                assignedTeams: [],
                evaluations: [evaluationsGLOBAL[4]],
                assignedProjectIds:
                    List<String>.from(doc['assigned_project_ids']),
                numberOfAssignedProjects:
                    int.tryParse(doc['number_of_assigned_projects'])));
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth * 0.97;

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
                        width: 35 * fem,
                      ),
                      SearchTextField(
                        textEditingController: panelIdController,
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
                      child: SingleChildScrollView(
                        child: AssignedPanelsDataTable(
                          assignedPanels: assignedPanels,
                          userRole: widget.userRole,
                          viewPanel: widget.viewPanel,
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
