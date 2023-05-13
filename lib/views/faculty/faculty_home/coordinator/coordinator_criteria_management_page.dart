import 'dart:math';

import 'package:casper/components/customised_text.dart';
import 'package:casper/components/form_custom_text.dart';
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
  bool loading = true, searching = false;
  List<EvaluationCriteria> evaluationCriterias = [];
  final courseController = TextEditingController(text: 'CP303'),
      yearSmesterController = TextEditingController(text: '2022-1');
  String course = 'CP303', yearSemester = '2022-1';
  final horizontalScrollController = ScrollController(),
      verticalScrollController = ScrollController();
  List<EvaluationCriteria> cachedEvaluationCriterias = [];

  // TODO: Implement this method

  bool updateSearchParameters() {
    setState(() {
      course = courseController.text.toString().toLowerCase().trim();
      yearSemester = yearSmesterController.text.toString().toLowerCase().trim();
    });
    if (course == '' || yearSemester == '') {
      return false;
    }
    return true;
  }

  void search() {
    print('now searching');
    setState(() {
      searching = true;
    });
    if (!updateSearchParameters()) {
      setState(() {
        searching = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: FormCustomText(
                text: 'Course and Year Semester cannot be empty',
              ),
            );
          });
      return;
    }
    setState(() {
      evaluationCriterias.clear();
    });
    print(cachedEvaluationCriterias.length);
    for (EvaluationCriteria evaluationCriteria in cachedEvaluationCriterias) {
      bool flag = true;
      if (!evaluationCriteria.course.toLowerCase().contains(course)) {
        flag = false;
      }
      print(flag);
      String tempSemYear =
          evaluationCriteria.year + '-' + evaluationCriteria.semester;
      if (!tempSemYear.toLowerCase().contains(yearSemester)) {
        flag = false;
      }
      print(flag);
      if (flag) {
        setState(() {
          searching = false;
          evaluationCriterias.add(evaluationCriteria);
        });
      }
    }
    setState(() {
      searching = false;
    });
  }

  Future<void> getCriteria() async {
    setState(() {
      evaluationCriterias = [];
    });
    await FirebaseFirestore.instance
        .collection('evaluation_criteria')
        .get()
        .then((value) async {
      for (var doc in value.docs) {
        setState(() {
          cachedEvaluationCriterias.add(EvaluationCriteria(
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
        setState(() {
          loading = false;
        });
      }
    });
    print(evaluationCriterias.length);
    print('got criteria');
    setState(() {
      loading = false;
      print(cachedEvaluationCriterias.length);
    });
    search();
  }

  String currentSemester = '', currentYear = '';

  void getSession() async {
    await FirebaseFirestore.instance
        .collection('current_session')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        var doc = value.docs[0];
        setState(() {
          currentSemester = doc['semester'];
          currentYear = doc['year'];
          yearSmesterController.text = '$currentYear-$currentSemester';
        });
      } else {
        print('faculty_panels_page.dart: No current session found');
      }
    });
    print('got session');
    await getCriteria();
    search();
  }

  @override
  void initState() {
    super.initState();
    evaluationCriterias = [];
    loading = true;
    searching = true;
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double wfem = (MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio) /
        baseWidth;
    double hfem = (MediaQuery.of(context).size.height *
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
                        Tooltip(
                          message: 'Course Code',
                          child: SearchTextField(
                            textEditingController: courseController,
                            hintText: 'Course',
                            width: 170 * wfem,
                          ),
                        ),
                        SizedBox(
                          width: 20 * wfem,
                        ),
                        Tooltip(
                          message: 'Session (Year-Session)',
                          child: SearchTextField(
                            textEditingController: yearSmesterController,
                            hintText: 'Session',
                            width: 170 * wfem,
                          ),
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
                            onPressed: () {
                              search();
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 1200 * wfem,
                      height: 1000 * hfem,
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
                        // TODO: Implement search
                        child: (searching
                            ? SizedBox(
                                width: double.infinity,
                                height: 500 * wfem,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 500,
                                width: 400,
                                child: Scrollbar(
                                  controller: verticalScrollController,
                                  thumbVisibility: true,
                                  trackVisibility: true,
                                  child: Scrollbar(
                                    controller: horizontalScrollController,
                                    thumbVisibility: true,
                                    trackVisibility: true,
                                    notificationPredicate: (notif) =>
                                        notif.depth == 1,
                                    child: SingleChildScrollView(
                                      controller: verticalScrollController,
                                      child: SingleChildScrollView(
                                        controller: horizontalScrollController,
                                        scrollDirection: Axis.horizontal,
                                        child: SizedBox(
                                          width: max(1217, 950 * wfem),
                                          child:
                                              CoordinatorCriteriaManagementDataTable(
                                            evaluationCriterias:
                                                evaluationCriterias,
                                            userRole: widget.userRole,
                                            viewProject: widget.viewCritera,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                      ),
                    ),
                    const SizedBox(
                      height: 65,
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
              height: 45 * wfem,
              width: 45 * wfem,
              margin: const EdgeInsets.fromLTRB(0, 0, 7, 0),
              child: Tooltip(
                message: 'Create Criteria',
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
                    // FirebaseFirestore.instance
                    //     .collection('instructors')
                    //     .get()
                    //     .then((value) {
                    //   for (var item in value.docs) {
                    //     FirebaseFirestore.instance
                    //         .collection('instructors')
                    //         .doc(item.id)
                    //         .update({
                    //       'number_of_projects_as_head': '0',
                    //       'project_as_head_ids': [],
                    //     });
                    //   }
                    // });
                    //
                    // FirebaseFirestore.instance
                    //     .collection('student')
                    //     .get()
                    //     .then((value) {
                    //   for (var item in value.docs) {
                    //     FirebaseFirestore.instance
                    //         .collection('student')
                    //         .doc(item.id)
                    //         .update({
                    //       'proj_id': [null, null, null, null, null],
                    //     });
                    //   }
                    // });

                    //TODO: uncomment
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
