import 'package:casper/components/customised_text.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/data_tables/faculty/coordinator/coordinator_criteria_management_data_table.dart';
import 'package:casper/models/models.dart';
import 'package:casper/models/seeds.dart';
import 'package:casper/views/shared/loading_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../components/add_criteria_form.dart';

class CoordinatorCriteriaManagementPage extends StatefulWidget {
  final String userRole;

  // ignore: prefer_typing_uninitialized_variables
  final viewCritera;

  const CoordinatorCriteriaManagementPage({
    Key? key,
    required this.userRole,
    required this.viewCritera,
  }) : super(key: key);

  @override
  State<CoordinatorCriteriaManagementPage> createState() =>
      _CoordinatorCriteriaManagementPageState();
}

class _CoordinatorCriteriaManagementPageState
    extends State<CoordinatorCriteriaManagementPage> {
  bool loading = false;
  List<EvaluationCriteria> evaluationCriterias = [];
  final courseController = TextEditingController(text: 'CP302'),
      yearSmesterController = TextEditingController(text: '2023-1');

  // TODO: Implement this method

  void getCriteria() {
    setState(() {
      evaluationCriterias.clear();
    });
    FirebaseFirestore.instance
        .collection('evaluation_criteria')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          evaluationCriterias.add(EvaluationCriteria(
              id: doc.id,
              weeksToConsider: int.parse(doc['weeksToConsider']),
              course: doc['course'],
              semester: doc['semester'],
              year: doc['year'],
              numberOfWeeks: int.parse(doc['numberOfWeeks']),
              regular: int.parse(doc['regular']),
              midtermSupervisor: int.parse(doc['midtermSupervisor']),
              midtermPanel: int.parse(doc['midtermPanel']),
              endtermSupervisor: int.parse(doc['endtermSupervisor']),
              endtermPanel: int.parse(doc['endtermPanel']),
              report: int.parse(doc['report'])));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    evaluationCriterias = [];
    getCriteria();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double wfem = (MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio) /
        baseWidth;

    if (loading) {
      return const LoadingPage();
    }

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
                          text: 'Criteria Management',
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
                          width: 33 * wfem,
                        ),
                        SearchTextField(
                          textEditingController: courseController,
                          hintText: 'Course',
                          width: 170 * wfem,
                        ),
                        SizedBox(
                          width: 20 * wfem,
                        ),
                        SearchTextField(
                          textEditingController: yearSmesterController,
                          hintText: 'Year-Semester',
                          width: 170 * wfem,
                        ),
                        SizedBox(
                          width: 25 * wfem,
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
                      width: 1200 * wfem,
                      height: 525 * wfem,
                      margin: EdgeInsets.fromLTRB(40, 15, 80 * wfem, 0),
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
                          child: CoordinatorCriteriaManagementDataTable(
                            evaluationCriterias: evaluationCriterias,
                            userRole: widget.userRole,
                            viewProject: widget.viewCritera,
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
                message: 'Add Criteria',
                child: FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 212, 203, 216),
                  splashColor: Colors.black,
                  hoverColor: Colors.grey,
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 35,
                  ),
                  // TODO: Implement this method
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Center(
                            child: AddCriteriaForm(
                              refresh: getCriteria,
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
