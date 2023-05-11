import 'dart:math';

import 'package:casper/comp/customised_text.dart';
import 'package:casper/components/form_custom_text.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/data_tables/faculty/faculty_enrollment_requests_data_table.dart';
import 'package:casper/models/models.dart';
import 'package:casper/views/shared/loading_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/confirm_action.dart';

class FacultyEnrollmentRequestsPage extends StatefulWidget {
  const FacultyEnrollmentRequestsPage({Key? key}) : super(key: key);

  @override
  State<FacultyEnrollmentRequestsPage> createState() =>
      _FacultyEnrollmentRequestsPageState();
}

class _FacultyEnrollmentRequestsPageState
    extends State<FacultyEnrollmentRequestsPage> {
  bool loading = true, searching = false;
  List<EnrollmentRequest> requests = [];
  var teamNames = {};
  String teamID = '', projectTitle = '', course = '', yearSemester = '';
  final teamIDController = TextEditingController(),
      projectTitleController = TextEditingController(),
      courseController = TextEditingController(text: 'CP303'),
      yearSemesterController = TextEditingController();
  final horizontalScrollController = ScrollController(),
      verticalScrollController = ScrollController();
  String currentYearSemester = '';

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

  void getSearchParameters() {
    setState(() {
      teamID = teamIDController.text.trim().toLowerCase();
      projectTitle = projectTitleController.text.trim().toLowerCase();
      course = courseController.text.trim().toLowerCase();
      yearSemester = yearSemesterController.text.trim().toLowerCase();
    });
  }

  void getEnrollmentRequests() async {
    print('called');
    await FirebaseFirestore.instance
        .collection('enrollment_requests')
        .where('status', isEqualTo: '2')
        .get()
        .then((value) async {
      for (var doc in value.docs) {
        var len = requests.length;
        await FirebaseFirestore.instance
            .collection('offerings')
            .where(FieldPath.documentId,
                isEqualTo: doc['offering_id'].toString().trim())
            .get()
            .then((value) async {
          for (var doc1 in value.docs) {
            if (doc1.id != doc['offering_id']) {
              continue;
            }
            print(doc1['instructor_name']);

            print(doc1['description']);
            if (doc1['instructor_id'] ==
                FirebaseAuth.instance.currentUser!.uid) {
              Project project = Project(
                  id: doc1.id,
                  title: doc1['title'],
                  description: doc1['description']);
              Faculty faculty = Faculty(id: '', name: '', email: '');
              await FirebaseFirestore.instance
                  .collection('instructors')
                  .where('uid', isEqualTo: doc1['instructor_id'])
                  .get()
                  .then((value) {
                for (var doc2 in value.docs) {
                  faculty = Faculty(
                      id: doc2['uid'],
                      name: doc2['name'],
                      email: doc2['email']);
                }
              });
              setState(() {
                Offering offering = Offering(
                    id: (len + 1).toString(),
                    project: project,
                    instructor: faculty,
                    semester: doc1['semester'],
                    year: doc1['year'],
                    course: doc1['type'],
                    key_id: doc1.id);
                EnrollmentRequest enrollment = EnrollmentRequest(
                    id: (len + 1).toString(),
                    status: doc['status'],
                    offering: offering,
                    teamId: doc['team_id'],
                    key_id: doc.id);
                bool flag = true;
                if (projectTitle != '') {
                  String title =
                      enrollment.offering.project.title.toLowerCase();
                  if (!title.contains(projectTitle)) flag = false;
                }
                if (teamID != '') {
                  String teamid = enrollment.teamId;
                  if (!teamid.contains(teamID)) flag = false;
                }
                String tempYearSem =
                    '${enrollment.offering.year}-${enrollment.offering.semester}';
                tempYearSem = tempYearSem.toLowerCase();
                String tempCourse = enrollment.offering.course.toLowerCase();
                print(tempYearSem + tempCourse);
                if (!tempYearSem.contains(yearSemester) ||
                    !tempCourse.contains(course)) flag = false;
                if (flag) requests.add(enrollment);
              });
              setState(() {
                for (var id in requests) {
                  teamNames[id.teamId] = [''];
                }
              });
              List<String> Team_ids = [];
              for (int i = 0; i < requests.length; i++) {
                Team_ids.add(requests[i].teamId);
                // print(Team_ids);
              }
              if (Team_ids.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('team')
                    .where('id', whereIn: Team_ids)
                    .get()
                    .then((value) async {
                  for (var doc in value.docs) {
                    List<String> temp = [];
                    for (String stud in doc['students']) {
                      if (!mounted) return;
                      await FirebaseFirestore.instance
                          .collection('student')
                          .where('id', isEqualTo: stud)
                          .get()
                          .then((value) {
                        for (var doc in value.docs) {
                          if (!mounted) return;
                          setState(() {
                            temp.add(doc['name']);
                          });
                        }
                      });
                    }
                    setState(() {
                      teamNames[doc['id']] = (temp);
                    });
                  }
                });
              }
              setState(() {
                loading = false;
              });
            }
          }
        });
      }
      setState(() {
        loading = false;
      });
    });
    setState(() {
      loading = false;
    });
  }

  void getSession() {
    FirebaseFirestore.instance
        .collection('current_session')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        var doc = value.docs[0];
        setState(() {
          currentYearSemester = doc['year'] + '-' + doc['semester'];
          yearSemesterController.text = currentYearSemester;
        });
      } else {
        setState(() {
          currentYearSemester = '';
        });
        print(
            'faculty_enrollment_requests_page.dart -> no valid session found');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getEnrollmentRequests();
    getSession();
  }

  void refresh() {
    setState(() {
      loading = true;
      requests = [];
      teamNames = {};
    });
    getEnrollmentRequests();
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
                      children: const [
                        CustomisedText(
                          text: 'Requests',
                          fontSize: 50,
                        ),
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
                          message: 'Project Title',
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
                          message: 'Team Identification Number',
                          child: SearchTextField(
                            textEditingController: teamIDController,
                            hintText: 'Team Identification',
                            width: 170 * wfem,
                          ),
                        ),
                        SizedBox(
                          width: 20 * wfem,
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
                              getSearchParameters();
                              if (yearSemester == '' || course == '') {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const AlertDialog(
                                        title: FormCustomText(
                                          text:
                                              'Year-Semester and course is mandatory',
                                        ),
                                      );
                                    });
                              }
                              refresh();
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
                                          child:
                                              FacultyEnrollmentRequestsDataTable(
                                            requests: requests,
                                            teamNames: teamNames,
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
