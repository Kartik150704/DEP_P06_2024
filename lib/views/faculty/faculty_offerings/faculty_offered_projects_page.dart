import 'dart:math';

import 'package:casper/components/add_project_form.dart';
import 'package:casper/comp/customised_text.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/data_tables/shared/offered_projects_data_table.dart';
import 'package:casper/models/models.dart';
import 'package:casper/views/shared/loading_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FacultyOfferedProjectsPage extends StatefulWidget {
  const FacultyOfferedProjectsPage({Key? key}) : super(key: key);

  @override
  State<FacultyOfferedProjectsPage> createState() =>
      _FacultyOfferedProjectsPageState();
}

class _FacultyOfferedProjectsPageState
    extends State<FacultyOfferedProjectsPage> {
  bool loading = true, searcing = false;
  List<Offering> offerings = [];
  var db = FirebaseFirestore.instance;
  String? supervisorName, projectTitle, course, year_semester;
  final instructorNameController = TextEditingController(),
      projectTitleController = TextEditingController(),
      courseController = TextEditingController(),
      yearSemesterController = TextEditingController(text: '2023-1');
  final horizontalScrollController = ScrollController(),
      verticalScrollController = ScrollController();

  void addProject() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: AddProjectForm(),
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
        .then(
      (value) async {
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
              if (!project.title.toLowerCase().contains(name)) {
                flag = 0;
              }
            }

            if (course != null) {
              String course = this.course.toString().toLowerCase();
              if (!doc['type'].toLowerCase().contains(course)) flag = 0;
            }

            if (year_semester != null) {
              String year_semester = doc['year'] + '-' + doc['semester'];
              if (!year_semester
                  .toLowerCase()
                  .contains(this.year_semester.toString().toLowerCase()))
                flag = 0;
            }
            if (flag == 1) {
              Offering offering = Offering(
                  id: (len + 1).toString(),
                  project: project,
                  instructor: faculty,
                  semester: doc['semester'],
                  year: doc['year'],
                  course: doc['type']);
              offerings.add(offering);
            }
          });
        }
        setState(() {
          loading = false;
          searcing = false;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    updateSearchParameters();
    getOfferings();
  }

  void refresh() {
    setState(() {
      loading = true;
    });
    updateSearchParameters();
    getOfferings();
  }

  bool updateSearchParameters() {
    setState(() {
      supervisorName = instructorNameController.text.trim() == ''
          ? null
          : instructorNameController.text.trim();
      projectTitle = projectTitleController.text.trim() == ''
          ? null
          : projectTitleController.text.trim();
      course = courseController.text.trim() == ''
          ? null
          : courseController.text.trim();
      year_semester = yearSemesterController.text.trim() == ''
          ? null
          : yearSemesterController.text.trim();
    });
    if (year_semester == null) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Center(
              child: Text('Course and Session are required'),
            ),
          );
        },
      );
      return false;
    }
    return true;
  }

  void search() {
    if (loading || searcing) return;
    setState(() {
      searcing = true;
    });
    getOfferings();
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
                          text: 'Offered Projects',
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
                          message: 'Instuctor\'s Name',
                          child: SearchTextField(
                            textEditingController: instructorNameController,
                            hintText: 'Instructor\'s Name',
                            width: 170 * wfem,
                          ),
                        ),
                        SizedBox(
                          width: 20 * wfem,
                        ),
                        Tooltip(
                          message: 'Course',
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
                          message: 'Year',
                          child: SearchTextField(
                            textEditingController: yearSemesterController,
                            hintText: 'Year',
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
                              if (updateSearchParameters()) search();
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
                        child: (searcing
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
                                            isStudent: false,
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
              ),
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
                message: 'Offer Project',
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
                    addProject();
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
