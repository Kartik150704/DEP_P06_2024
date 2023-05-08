import 'dart:math';

import 'package:casper/components/confirm_action.dart';
import 'package:casper/comp/customised_text.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/data_tables/shared/offered_projects_data_table.dart';
import 'package:casper/models/models.dart';
import 'package:casper/views/shared/loading_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentOfferedProjectsPage extends StatefulWidget {
  const StudentOfferedProjectsPage({Key? key}) : super(key: key);

  @override
  State<StudentOfferedProjectsPage> createState() =>
      _StudentOfferedProjectsPageState();
}

class _StudentOfferedProjectsPageState
    extends State<StudentOfferedProjectsPage> {
  bool loading = true, searching = false;
  String? supervisorName, projectTitle, course, yearSemester;
  List<Offering> offerings = [];
  final supervisorNameController = TextEditingController(),
      projectTitleController = TextEditingController(),
      courseCodeController = TextEditingController(),
      yearSemesterController = TextEditingController(text: '2023-1');
  final horizontalScrollController = ScrollController(),
      verticalScrollController = ScrollController();

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

  void getOfferings() {
    offerings.clear();
    FirebaseFirestore.instance
        .collection('offerings')
        .where('status', isEqualTo: 'open')
        .get()
        .then((value) async {
      int idnum = 1;
      for (var doc in value.docs) {
        var len = offerings.length;
        Project project = Project(
            id: doc.id, title: doc['title'], description: doc['description']);
        Faculty faculty = Faculty(id: '', name: '', email: '');
        await FirebaseFirestore.instance
            .collection('instructors')
            .where('uid', isEqualTo: doc['instructor_id'])
            .get()
            .then((value) {
          for (var doc1 in value.docs) {
            faculty = Faculty(
                id: doc1['uid'], name: doc1['name'], email: doc1['email']);
          }
        });
        setState(() {
          int flag = 1;
          if (supervisorName != null) {
            String name = supervisorName.toString().toLowerCase();
            if (!faculty.name.toLowerCase().contains(name)) flag = 0;
          }

          if (projectTitle != null) {
            String name = projectTitle.toString().toLowerCase();
            if (!project.title.toLowerCase().contains(name.toLowerCase())) {
              flag = 0;
            }
          }

          String semestersearch = yearSemesterController.text.split('-')[1];
          String yearsearch = yearSemesterController.text.split('-')[0];
          if (semestersearch != null) {
            String semester = semestersearch.toString().toLowerCase();
            if (!doc['semester'].toLowerCase().contains(semester)) flag = 0;
          }

          if (yearsearch != null) {
            String year = yearsearch.toString().toLowerCase();
            if (!doc['year'].toLowerCase().contains(year)) flag = 0;
          }

          FirebaseFirestore.instance
              .collection('student')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .get()
              .then((value) {
            var docx = value.docs[0];
            String studendId = docx['id'];
            FirebaseFirestore.instance
                .collection('team')
                .get()
                .then((teamdocs) {
              String? teamId;
              for (var teamdoc in teamdocs.docs) {
                if (teamdoc['students'].contains(studendId)) {
                  teamId = teamdoc['id'];
                  break;
                }
              }
              if (teamId != null) {
                FirebaseFirestore.instance
                    .collection('enrollment_requests')
                    .where('team_id', isEqualTo: teamId)
                    .where('offering_id', isEqualTo: doc.id)
                    .get()
                    .then((requestDocs) {
                  if (requestDocs.docs.length != 0) {
                    flag = 0;
                  }
                  if (flag == 1) {
                    Offering offering = Offering(
                        id: (idnum++).toString(),
                        project: project,
                        instructor: faculty,
                        semester: doc['semester'],
                        year: doc['year'],
                        course: doc['type'],
                        key_id: doc.id);
                    setState(() {
                      offerings.add(offering);
                    });
                  }
                });
              }
            });
          });
        });
      }
      setState(() {
        loading = false;
        searching = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getOfferings();
  }

  void refresh() {
    setState(() {
      loading = true;
      getOfferings();
    });
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
                  const CustomisedText(
                    text: 'Offered Projects',
                    fontSize: 50,
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
                        message: 'Title Of The Project',
                        child: SearchTextField(
                          textEditingController: projectTitleController,
                          hintText: 'Project',
                          width: 170 * wfem,
                        ),
                      ),
                      SizedBox(
                        width: 20 * wfem,
                      ),
                      Tooltip(
                        message: 'Name Of The Supervisor',
                        child: SearchTextField(
                          textEditingController: supervisorNameController,
                          hintText: 'Supervisor\'s Name',
                          width: 170 * wfem,
                        ),
                      ),
                      SizedBox(
                        width: 20 * wfem,
                      ),
                      Tooltip(
                        message: 'Code Of The Course',
                        child: SearchTextField(
                          textEditingController: courseCodeController,
                          hintText: 'Course',
                          width: 170 * wfem,
                        ),
                      ),
                      SizedBox(
                        width: 20 * wfem,
                      ),
                      Tooltip(
                        message: 'Session (Year-Semester)',
                        child: SearchTextField(
                          textEditingController: yearSemesterController,
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
                            setState(() {
                              projectTitle =
                                  projectTitleController.text.trim() == ''
                                      ? null
                                      : projectTitleController.text.trim();
                              supervisorName =
                                  supervisorNameController.text.trim() == ''
                                      ? null
                                      : supervisorNameController.text.trim();
                              course = courseCodeController.text.trim() == ''
                                  ? null
                                  : courseCodeController.text.trim();
                              yearSemester =
                                  yearSemesterController.text.trim() == ''
                                      ? null
                                      : yearSemesterController.text.trim();
                            });
                            if (yearSemester == null) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      title: CustomisedText(
                                        text: 'year-semester cannot be empty',
                                        color: Colors.black,
                                      ),
                                    );
                                  });
                              return;
                            }
                            setState(() {
                              searching = true;
                            });
                            getOfferings();
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
                                        child: OfferedProjectsDataTable(
                                          offerings: offerings,
                                          isStudent: true,
                                          refresh: refresh,
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
