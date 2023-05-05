import 'package:casper/components/customised_text.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/data_tables/shared/project_data_table.dart';
import 'package:casper/models/models.dart';
import 'package:casper/models/seeds.dart';
import 'package:casper/views/shared/loading_page.dart';
import 'package:casper/views/shared/project_page/no_projects_found_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProjectPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final projectId, selectOption, isFaculty;

  const ProjectPage({
    Key? key,
    required this.projectId,
    this.selectOption,
    this.isFaculty = false,
  }) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  bool loading = true, searching = false;

  // TODO: Fetch these values from db
  Enrollment? enrollment;
  List<AssignedPanel> assignedPanels = [];
  ReleasedEvents releasedEvents = releasedEventsGLOBAL[0];
  String evaluation_doc_id = '';
  final eventController = TextEditingController(),
      studentNameController = TextEditingController(),
      studentEntryNumberController = TextEditingController();

  List<Evaluation> supervisorEvaluations = [];

  Team team = teamsGLOBAL[0];

  // TODO: heavy refactoring of query, but it works as of now

  void getAssignedPanels() {
    FirebaseFirestore.instance
        .collection('evaluations')
        .where('project_id', isEqualTo: widget.projectId)
        .get()
        .then((value) {
      var doc = value.docs[0];
      setState(() {
        evaluation_doc_id = doc.id;
      });
      List<String> assignedPanelIds = List<String>.generate(
          doc['assigned_panels'].length,
          (index) => doc['assigned_panels'][index].toString());
      if (assignedPanelIds.length == 0) {
        setState(() {
          loading = false;
        });
        return;
      }
      Map assignedPanelTerm = {},
          assignedPanelSemester = {},
          assignedPanelYear = {},
          assignedPanelPanelId = {},
          assignedPanelCourse = {},
          assignedPanelNumberOfEvaluators = {},
          assignedPanelEvaluatorIds = {},
          assignedPanelEvaluatorNames = {},
          assignedPanelAssignedProjects = {};

      if (assignedPanelIds.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('assigned_panel')
            .where(FieldPath.documentId, whereIn: assignedPanelIds)
            .get()
            .then((assignedPanelDocs) {
          for (var assignedPanelDoc in assignedPanelDocs.docs) {
            assignedPanelTerm[assignedPanelDoc.id] = assignedPanelDoc['term'];
            assignedPanelSemester[assignedPanelDoc.id] =
                assignedPanelDoc['semester'];
            assignedPanelYear[assignedPanelDoc.id] = assignedPanelDoc['year'];
            assignedPanelPanelId[assignedPanelDoc.id] =
                assignedPanelDoc['panel_id'];
            assignedPanelCourse[assignedPanelDoc.id] =
                assignedPanelDoc['course'];
            assignedPanelNumberOfEvaluators[assignedPanelDoc.id] =
                int.tryParse(assignedPanelDoc['number_of_evaluators']);
            assignedPanelEvaluatorIds[assignedPanelDoc.id] =
                assignedPanelDoc['evaluator_ids'];
            assignedPanelEvaluatorNames[assignedPanelDoc.id] =
                assignedPanelDoc['evaluator_names'];
            assignedPanelAssignedProjects[assignedPanelDoc.id] =
                assignedPanelDoc['assigned_project_ids'];
          }

          for (String assignedPanelId in assignedPanelIds) {
            List<Evaluation> panelEvaluations = [];
            if (assignedPanelTerm[assignedPanelId].contains('Mid')) {
              for (int i = 0; i < doc['midsem_evaluation'].length; i++) {
                var eval = doc['midsem_evaluation'][i];

                eval.forEach((key, value) {
                  Evaluation evaluation = Evaluation(
                    id: '1',
                    marks: double.parse(value),
                    remarks: doc['midsem_panel_comments'][i][key],
                    type: 'midterm-panel',
                    student: Student(
                        id: key,
                        name: 'name placeholder',
                        entryNumber: key,
                        email: '$key@iitrpr.ac.in'),
                    faculty: Faculty(
                        id: assignedPanelEvaluatorIds[assignedPanelId][i],
                        name: assignedPanelEvaluatorNames[assignedPanelId][i],
                        email: 'email placeholder project_data_table.dart'),
                  );
                  // panelEvaluations.add(evaluation);
                });
              }
            }
            AssignedPanel assignedPanel = AssignedPanel(
              id: assignedPanelId,
              course: assignedPanelCourse[assignedPanelId],
              term: assignedPanelTerm[assignedPanelId],
              semester: assignedPanelSemester[assignedPanelId],
              year: assignedPanelYear[assignedPanelId],
              panel: Panel(
                  id: assignedPanelPanelId[assignedPanelId],
                  course: assignedPanelCourse[assignedPanelId],
                  semester: assignedPanelSemester[assignedPanelId],
                  year: assignedPanelYear[assignedPanelId],
                  numberOfEvaluators:
                      assignedPanelNumberOfEvaluators[assignedPanelId],
                  evaluators: [
                    for (int i = 0;
                        i < assignedPanelNumberOfEvaluators[assignedPanelId];
                        i++)
                      Faculty(
                        id: assignedPanelEvaluatorIds[assignedPanelId][i],
                        name: assignedPanelEvaluatorNames[assignedPanelId][i],
                        email: 'email placeholder project_data_table.dart',
                      )
                  ]),
              numberOfAssignedTeams: 1,
              assignedTeams: [team],
              evaluations: panelEvaluations,
            );
            setState(() {
              assignedPanels.add(assignedPanel);
              loading = false;
            });
          }
        });
      }
    });
  }

  void getEnrollmentDetails() {
    FirebaseFirestore.instance
        .collection('evaluations')
        .where('project_id', isEqualTo: widget.projectId)
        .get()
        .then((value) {
      if (value.docs.length == 0) {
        setState(() {
          loading = false;
        });
        return;
      }
      var doc = value.docs[0];
      int n = int.tryParse(doc['number_of_evaluations'])!;
      List<String> studentIds = List<String>.generate(
          doc['student_ids'].length, (index) => doc['student_ids'][index]);
      List<String> studentNames = List<String>.generate(
          doc['student_names'].length, (index) => doc['student_names'][index]);
      FirebaseFirestore.instance
          .collection('instructors')
          .where('uid', isEqualTo: doc['supervisor_id'])
          .get()
          .then((facultyDocs) {
        var facultyDoc = facultyDocs.docs[0];
        Faculty faculty = Faculty(
          id: facultyDoc['uid'],
          name: facultyDoc['name'],
          email: facultyDoc['email'],
        );

        for (int i = 0; i < n; i++) {
          for (int j = 0; j < studentIds.length; j++) {
            String studentId = studentIds[j], studentName = studentNames[j];
            setState(() {
              if (doc['weekly_evaluations'][i][studentId] == null) return;
              supervisorEvaluations.add(Evaluation(
                type: 'week-${i + 1}',
                marks: double.parse(doc['weekly_evaluations'][i][studentId]),
                remarks: doc['weekly_comments'][i][studentId] ?? '',
                student: Student(
                  id: studentId,
                  name: studentName,
                  entryNumber: studentId,
                  email: '$studentId@iitrpr.ac.in',
                ),
                id: doc.id,
                faculty: faculty,
              ));
            });
          }
        }

        FirebaseFirestore.instance
            .collection('projects')
            .where(FieldPath.documentId, isEqualTo: widget.projectId)
            .get()
            .then((value) {
          var doc = value.docs[0];
          setState(() {
            enrollment = Enrollment(
                id: doc.id,
                offering: Offering(
                  id: doc['offering_id'],
                  instructor: faculty,
                  course: doc['type'],
                  semester: doc['semester'],
                  year: doc['year'],
                  project: Project(
                    id: doc['offering_id'],
                    title: doc['title'],
                    description: doc['description'],
                  ),
                ),
                team: Team(
                  id: doc['team_id'],
                  numberOfMembers: doc['student_ids'].length,
                  students: [
                    for (int i = 0; i < doc['student_ids'].length; i++)
                      Student(
                        id: doc['student_ids'][i],
                        name: doc['student_name'][i],
                        entryNumber: doc['student_ids'][i],
                        email: '${doc['student_ids'][i]}@iitrpr.ac.in',
                      )
                  ],
                ),
                supervisorEvaluations: supervisorEvaluations);
            setState(() {
              team = Team(
                id: doc['team_id'],
                numberOfMembers: doc['student_ids'].length,
                students: [
                  for (int i = 0; i < doc['student_ids'].length; i++)
                    Student(
                      id: doc['student_ids'][i],
                      name: doc['student_name'][i],
                      entryNumber: doc['student_ids'][i],
                      email: '${doc['student_ids'][i]}@iitrpr.ac.in',
                    )
                ],
              );
            });

            getAssignedPanels();
          });
        });
      });
    });
  }

  void getProjectDetails() {
    if (widget.projectId == null) {
      setState(() {
        loading = false;
      });
      return;
    }
    getEnrollmentDetails();
  }

  @override
  void initState() {
    super.initState();
    getProjectDetails();

    // // TODO: This is temporary, do this in above function instead
    // setState(() {
    //   loading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = (MediaQuery.of(context).size.width / baseWidth);

    if (loading) {
      return const LoadingPage();
    }
    print(widget.projectId);
    if (widget.projectId == null) {
      return NoProjectsFoundPage(
        selectOption: widget.selectOption,
      );
    }

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
                      CustomisedText(
                        text: enrollment?.offering.project.title,
                        fontSize: 50,
                      ),
                      Container(),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: CustomisedText(
                      text:
                          '${enrollment?.offering.instructor.name}, ${enrollment?.offering.year}-${enrollment?.offering.semester}',
                      fontSize: 22,
                    ),
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
                      Tooltip(
                        message: 'Type Of The Event',
                        child: SearchTextField(
                          textEditingController: eventController,
                          hintText: 'Event',
                          width: 170 * fem,
                        ),
                      ),
                      SizedBox(
                        width: 20 * fem,
                      ),
                      Tooltip(
                        message: 'Name Of The Student',
                        child: SearchTextField(
                          textEditingController: studentNameController,
                          hintText: 'Student\'s Name',
                          width: 170 * fem,
                        ),
                      ),
                      SizedBox(
                        width: 20 * fem,
                      ),
                      Tooltip(
                        message: 'Entry Number Of The Student',
                        child: SearchTextField(
                          textEditingController: studentEntryNumberController,
                          hintText: 'Student Entry Number',
                          width: 170 * fem,
                        ),
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
                    height: 505 * fem,
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
                      child: (searching
                          ? SizedBox(
                              width: double.infinity,
                              height: 500 * fem,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              // ignore: prefer_const_constructors
                              child: ProjectDataTable(
                                enrollment: enrollment,
                                assignedPanels: assignedPanels,
                                releasedEvents: releasedEvents,
                                isFaculty: widget.isFaculty,
                                evaluation_doc_id: evaluation_doc_id,
                              ),
                            )),
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
