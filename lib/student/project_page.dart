import 'package:casper/components/customised_button.dart';
import 'package:casper/components/evaluation_data_table.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/student/no_projects_found_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProjectPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final project_id, isFaculty;

  ProjectPage({
    Key? key,
    this.project_id,
    this.isFaculty = false,
  }) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  var project_details = [];
  List<Evaluation> evaluations = [];

  void fetchEvaluations() {
    var project_id = widget.project_id;
    FirebaseFirestore.instance
        .collection('evaluations')
        .where('project_id', isEqualTo: project_id)
        .get()
        .then((value) {
      // print(value.docs.length);
      var doc = value.docs[0];
      int n = int.tryParse(doc['number_of_evaluations'])!;
      List<String> studentIds = List<String>.generate(
          doc['student_ids'].length, (index) => doc['student_ids'][index]);
      List<String> studentNames = List<String>.generate(
          doc['student_names'].length, (index) => doc['student_names'][index]);
      for (int i = 0; i < n; i++) {
        for (int j = 0; j < studentIds.length; j++) {
          String studentId = studentIds[j], studentName = studentNames[j];
          setState(() {
            evaluations.add(Evaluation(
              week: (i + 1).toString(),
              date: '05/04 - 12/04',
              marks: doc['weekly_evaluations'][i][studentId] ?? '',
              remarks: doc['weekly_comments'][i][studentId] ?? '',
              status:
                  doc['weekly_evaluations'][i][studentId] == null ? '1' : '2',
              evaluation_id: doc.id,
              student_id: studentId,
              student_name: studentName,
            ));
          });
        }
      }
    });
  }

  void fetchProject() {
    setState(() {
      project_details = [];
      evaluations = [];
    });
    fetchEvaluations();
    FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.project_id)
        .get()
        .then((value) {
      var doc = value.data();
      setState(() {
        project_details.add(doc!['title']);
        project_details.add(doc['instructor_name']);
        project_details.add(doc['year']);
        project_details.add(doc['semester']);
        project_details.add(doc['student_name']);
        project_details.add(doc['description']);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProject();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = (MediaQuery.of(context).size.width / baseWidth) * 0.97;

    if (widget.project_id == null) {
      return const NoProjectsFoundPage();
    } else if (project_details.length < 5) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      );
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
                      text: project_details[0],
                      fontSize: 50,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomisedText(
                      text: project_details[5],
                      fontSize: 25,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: CustomisedText(
                            text: project_details[1] +
                                ' - ' +
                                project_details[2] +
                                ' ' +
                                project_details[3],
                            fontSize: 25,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomisedText(
                              text: project_details[4][0],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomisedText(
                              text: project_details[4][1],
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
                        color: const Color.fromARGB(255, 70, 67, 83),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            spreadRadius: 3,
                            blurRadius: 20,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      // ignore: prefer_const_constructors
                      child: SingleChildScrollView(
                        // ignore: prefer_const_constructors
                        child: EvaluationDataTable(
                          refresh: fetchProject,
                          isFaculty: widget.isFaculty,
                          evaluations: evaluations,
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
}

class Evaluation {
  final String week,
      date,
      marks,
      remarks,
      status,
      evaluation_id,
      student_id,
      student_name;

  const Evaluation({
    required this.week,
    required this.date,
    required this.marks,
    required this.remarks,
    required this.status,
    required this.evaluation_id,
    required this.student_id,
    required this.student_name,
  });
}
