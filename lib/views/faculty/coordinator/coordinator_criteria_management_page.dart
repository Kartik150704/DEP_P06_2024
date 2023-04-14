import 'package:casper/components/customised_text.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/data_tables/faculty/coordinator_criteria_management_data_table.dart';
import 'package:casper/models/models.dart';
import 'package:casper/seeds.dart';
import 'package:flutter/material.dart';

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
  List<EvaluationCriteria> evaluationCriterias = [];
  final courseController = TextEditingController(),
      yearController = TextEditingController(text: '2023'),
      semesterController = TextEditingController(text: '1');

  // TODO: Implement this method
  @override
  void initState() {
    super.initState();
    evaluationCriterias = evaluationCriteriasGLOBAL;
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
                        width: 33 * fem,
                      ),
                      SearchTextField(
                        textEditingController: courseController,
                        hintText: 'Course',
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
                        width: 20 * fem,
                      ),
                      SearchTextField(
                        textEditingController: semesterController,
                        hintText: 'Semester',
                        width: 170 * fem,
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
    );
  }
}
