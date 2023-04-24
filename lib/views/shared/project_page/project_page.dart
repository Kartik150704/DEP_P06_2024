import 'package:casper/components/customised_text.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/data_tables/shared/project_data_table.dart';
import 'package:casper/models/models.dart';
import 'package:casper/models/seeds.dart';
import 'package:casper/views/shared/loading_page.dart';
import 'package:casper/views/shared/project_page/no_projects_found_page.dart';
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
  Enrollment enrollment = enrollmentsGLOBAL[0];
  AssignedPanel assignedPanel = assignedPanelsGLOBAL[0];
  ReleasedEvents releasedEvents = releasedEventsGLOBAL[0];
  final eventController = TextEditingController(),
      studentNameController = TextEditingController(),
      studentEntryNumberController = TextEditingController();

  // void getEnrollmentDetails() {
  //   FirebaseFirestore.instance
  //       .collection('evaluations')
  //       .where('project_id', isEqualTo: widget.projectId)
  //       .get()
  //       .then((value) {
  //     var doc = value.docs[0];
  //     int n = int.tryParse(doc['number_of_evaluations'])!;
  //     List<String> studentIds = List<String>.generate(
  //         doc['student_ids'].length, (index) => doc['student_ids'][index]);
  //     List<String> studentNames = List<String>.generate(
  //         doc['student_names'].length, (index) => doc['student_names'][index]);
  //     for (int i = 0; i < n; i++) {
  //       for (int j = 0; j < studentIds.length; j++) {
  //         String studentId = studentIds[j], studentName = studentNames[j];
  //         setState(() {
  //           evaluations.add(Evaluation(
  //             week: (i + 1).toString(),
  //             date: '05/04 - 12/04',
  //             marks: doc['weekly_evaluations'][i][studentId] ?? '',
  //             remarks: doc['weekly_comments'][i][studentId] ?? '',
  //             status:
  //                 doc['weekly_evaluations'][i][studentId] == null ? '1' : '2',
  //             evaluationId: doc.id,
  //             studentId: studentId,
  //             studentName: studentName,
  //           ));
  //         });
  //       }
  //     }
  //   });
  // }

  // void getProjectDetails() {
  //   if (widget.projectId == null) {
  //     setState(() {
  //       loading = false;
  //     });
  //     return;
  //   }

  //   setState(() {
  //     projectDetails = [];
  //     enrollments = [];
  //   });
  //   getEnrollmentDetails();
  //   FirebaseFirestore.instance
  //       .collection('projects')
  //       .doc(widget.projectId)
  //       .get()
  //       .then((value) {
  //     var doc = value.data();
  //     setState(() {
  //       projectDetails.add(doc!['title']);
  //       projectDetails.add(doc['instructor_name']);
  //       projectDetails.add(doc['year']);
  //       projectDetails.add(doc['semester']);
  //       projectDetails.add(doc['studentName']);
  //       projectDetails.add(doc['description']);
  //     });
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // getProjectDetails(); using projectId

    // TODO: This is temporary, do this in above function instead
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = (MediaQuery.of(context).size.width / baseWidth);

    if (loading) {
      return const LoadingPage();
    }

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
                        text: enrollment.offering.project.title,
                        fontSize: 50,
                      ),
                      Container(),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: CustomisedText(
                      text:
                          '${enrollment.offering.instructor.name}, ${enrollment.offering.year}-${enrollment.offering.semester}',
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
                                assignedPanel: assignedPanel,
                                releasedEvents: releasedEvents,
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
