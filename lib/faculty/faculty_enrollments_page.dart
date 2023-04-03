import 'package:casper/components/customised_text.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/models.dart';
import 'package:casper/components/enrollments_data_table.dart';
import 'package:casper/seeds.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FacultyEnrollmentsPage extends StatefulWidget {
  final String role;
  // ignore: prefer_typing_uninitialized_variables
  final showProject;

  const FacultyEnrollmentsPage({
    Key? key,
    required this.showProject,
    this.role = 'su',
  }) : super(key: key);

  @override
  State<FacultyEnrollmentsPage> createState() => _FacultyEnrollmentsPageState();
}

class _FacultyEnrollmentsPageState extends State<FacultyEnrollmentsPage> {
  bool? ischecked = false;
  final List<Enrollment> enrollments = [];
  final projectTitleController = TextEditingController(),
      semesterController = TextEditingController(),
      studentNameController = TextEditingController(),
      courseCodeController = TextEditingController(),
      yearController = TextEditingController();

  dynamic displayPage;

  // TODO: Modify database and implement this method
  void getSupervisorEnrollments() {
    setState(() {
      enrollments.clear();
    });

    FirebaseFirestore.instance
        .collection('instructors')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((snapshot) {
      FirebaseFirestore.instance
          .collection('projects')
          .where(
            FieldPath.documentId,
            whereIn: snapshot.docs[0]['project_as_head_ids'],
          )
          .get()
          .then((value) {
        for (var doc in value.docs) {
          final val = doc.data();
          setState(() {
            enrollments.add(
              // Enrollment(
              //   title: val['title'],
              //   students:
              //       val['student_name'][0] + ', ' + val['student_name'][1],
              //   semester: val['semester'],
              //   year: val['year'],
              //   description: val['description'],
              //   projectId: doc.id,
              // ),
              Enrollment(
                id: '-1',
                offering: Offering(
                  id: '-1',
                  instructor: Faculty(
                    id: '-1',
                    name: 'null',
                    email: 'null',
                  ),
                  course: 'CP302',
                  semester: val['semester'],
                  year: val['year'],
                  project: Project(
                    id: doc.id,
                    title: val['title'],
                    description: val['description'],
                  ),
                ),
                team: Team(
                  id: '1',
                  numberOfMembers: 2,
                  students: [
                    Student(
                      id: '1',
                      name: val['student_name'][1],
                      entryNumber: 'null',
                      email: 'null',
                    ),
                    Student(
                      id: '2',
                      name: val['student_name'][0],
                      entryNumber: 'null',
                      email: 'null',
                    ),
                  ],
                ),
                supervisorEvaluations: [
                  evaluationsGLOBAL[6],
                  evaluationsGLOBAL[7],
                  evaluationsGLOBAL[8],
                ],
              ),
            );
          });
        }
      });
    });
  }

  // TODO: Implement this method
  @override
  void initState() {
    super.initState();
    getSupervisorEnrollments();
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
                        text: 'My Enrollments',
                        fontSize: 50,
                      ),
                      // (widget.role == 'co')
                      //     ? SizedBox(
                      //         width: 200,
                      //         child: Row(
                      //           children: [
                      //             Checkbox(
                      //               value: ischecked,
                      //               onChanged: (bool? value) {
                      //                 setState(
                      //                   () {
                      //                     ischecked = value;
                      //                     if (ischecked!) {
                      //                       getSupervisorEnrollments();
                      //                     } else {
                      //                       getAllEnrollments();
                      //                     }
                      //                   },
                      //                 );
                      //               },
                      //               checkColor: Colors.white,
                      //               side: const BorderSide(color: Colors.white),
                      //             ),
                      //             const CustomisedText(
                      //               text: 'My Enrollments Only',
                      //               fontSize: 10,
                      //               color: Colors.white,
                      //             ),
                      //           ],
                      //         ),
                      //       )
                      //     : Container(),
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
                        textEditingController: projectTitleController,
                        hintText: 'Project Title',
                        width: 170 * fem,
                      ),
                      SizedBox(
                        width: 20 * fem,
                      ),
                      SearchTextField(
                        textEditingController: studentNameController,
                        hintText: 'Student Name',
                        width: 170 * fem,
                      ),
                      SizedBox(
                        width: 20 * fem,
                      ),
                      SearchTextField(
                        textEditingController: courseCodeController,
                        hintText: 'Course Code',
                        width: 170 * fem,
                      ),
                      SizedBox(
                        width: 20 * fem,
                      ),
                      SearchTextField(
                        textEditingController: semesterController,
                        hintText: 'Year',
                        width: 170 * fem,
                      ),
                      SizedBox(
                        width: 20 * fem,
                      ),
                      SearchTextField(
                        textEditingController: yearController,
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
                        child: EnrollmentsDataTable(
                          enrollments: enrollments,
                          userRole: widget.role,
                          showProject: widget.showProject,
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
