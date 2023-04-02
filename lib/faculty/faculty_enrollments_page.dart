import 'package:casper/components/customised_text.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/utilites.dart';
import 'package:casper/components/customised_text_field.dart';
import 'package:casper/components/enrollment_data_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FacultyEnrollmentsPage extends StatefulWidget {
  final String role;

  const FacultyEnrollmentsPage({
    Key? key,
    this.role = 'su',
  }) : super(key: key);

  @override
  State<FacultyEnrollmentsPage> createState() => _FacultyEnrollmentsPageState();
}

class _FacultyEnrollmentsPageState extends State<FacultyEnrollmentsPage> {
  bool? ischecked = false;
  late List<Enrollment> enrollments = [];
  final projectTitleController = TextEditingController(),
      supervisorNameController = TextEditingController(),
      studentNameController = TextEditingController(),
      courseCodeController = TextEditingController(),
      yearSemesterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.role == 'su') {
      getSupervisorEnrollments();
    } else {
      getAllEnrollments();
    }
  }

  void getSupervisorEnrollments() {
    setState(() {
      enrollments = [];
    });

    FirebaseFirestore.instance
        .collection('instructors')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((snapshot) {
      FirebaseFirestore.instance
          .collection('projects')
          .where(FieldPath.documentId,
              whereIn: snapshot.docs[0]['project_as_head_ids'])
          .get()
          .then((value) {
        for (var doc in value.docs) {
          final val = doc.data();
          setState(() {
            enrollments.add(Enrollment(
              title: val['title'],
              sname1: val['student_name'][0],
              sname2: val['student_name'][1],
              sem: val['semester'],
              year: val['year'],
              description: val['description'],
              projectId: doc.id,
            ));
          });
        }
      });
    });
  }

  void getAllEnrollments() {
    setState(() {
      enrollments = [];
    });

    FirebaseFirestore.instance.collection('projects').get().then((value) {
      for (var doc in value.docs) {
        final val = doc.data();
        setState(() {
          enrollments.add(
            Enrollment(
              title: val['title'],
              sname1: val['student_name'][0],
              sname2: val['student_name'][1],
              sem: val['semester'],
              year: val['year'],
              description: val['description'],
              projectId: doc.id,
            ),
          );
        });
      }
    });
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
                        text: 'Enrollments',
                        fontSize: 50,
                      ),
                      (widget.role == 'co')
                          ? SizedBox(
                              width: 200,
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: ischecked,
                                    onChanged: (bool? value) {
                                      setState(
                                        () {
                                          ischecked = value;
                                          if (ischecked!) {
                                            getSupervisorEnrollments();
                                          } else {
                                            getAllEnrollments();
                                          }
                                        },
                                      );
                                    },
                                    checkColor: Colors.white,
                                    side: const BorderSide(color: Colors.white),
                                  ),
                                  const CustomisedText(
                                    text: 'My Enrollments Only',
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          : Container(),
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
                        textEditingController: supervisorNameController,
                        hintText: 'Supervisor Name',
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
                        textEditingController: yearSemesterController,
                        hintText: 'Year-Semester',
                        width: 170 * fem,
                      ),
                      SizedBox(
                        width: 25 * fem,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[300],
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search,
                          ),
                          iconSize: 25,
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
                        child: EnrollmentDataTable(
                          enrollments: enrollments,
                          role: widget.role,
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

class Enrollment {
  final String title, sname1, sname2, sem, year, description, projectId;

  const Enrollment({
    required this.title,
    required this.sname1,
    required this.sname2,
    required this.sem,
    required this.year,
    required this.description,
    required this.projectId,
  });
}
