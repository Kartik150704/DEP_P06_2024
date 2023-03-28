import 'package:casper/components/projecttile.dart';
import 'package:casper/faculty/loggedinscaffoldFaculty.dart';
import 'package:casper/student/project_page.dart';
import 'package:casper/utilites.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/components/customised_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/enrollment_data_table.dart';
import 'package:flutter/rendering.dart';
import '../components/customised_text.dart';
import '../components/text_field.dart';

class EnrollmentsPageFaculty extends StatefulWidget {
  final String role;

  EnrollmentsPageFaculty({Key? key, this.role = 'su'}) : super(key: key);

  @override
  State<EnrollmentsPageFaculty> createState() => _EnrollmentsPageFacultyState();
}

class _EnrollmentsPageFacultyState extends State<EnrollmentsPageFaculty> {
  final semester_controller = TextEditingController(),
      year_controller = TextEditingController(),
      supervisor_name_controller = TextEditingController(),
      project_title_controller = TextEditingController();

  bool? ischecked = false;

  late List<Enrollment> enrollments = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.role == 'su') {
      supervisorEnrollments();
    } else {
      allEnrollments();
    }
  }

  void supervisorEnrollments() {
    setState(() {
      enrollments = [];
    });
    final List<Enrollment> enrollments_data = [];
    // List<dynamic> project_list
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
              name: val['title'],
              sname1: val['student_name'][0],
              sname2: val['student_name'][1],
              sem: val['semester'],
              year: val['year'],
              description: val['description'],
              project_id: doc.id,
            ));
          });
          // print(val);
        }
      });
    });
  }

  void allEnrollments() {
    setState(() {
      enrollments = [];
    });
    FirebaseFirestore.instance.collection('projects').get().then((value) {
      for (var doc in value.docs) {
        final val = doc.data();
        setState(() {
          enrollments.add(
            Enrollment(
              name: val['title'],
              sname1: val['student_name'][0],
              sname2: val['student_name'][1],
              sem: val['semester'],
              year: val['year'],
              description: val['description'],
              project_id: doc.id,
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
    double ffem = fem * 0.97;
    return Expanded(
      child: Container(
        color: const Color(0xff302c42),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Text(
                        'Enrollments',
                        style: SafeGoogleFont(
                          'Ubuntu',
                          fontSize: 50,
                          fontWeight: FontWeight.w700,
                          color: Color(0xffffffff),
                        ),
                      ),
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
                                          supervisorEnrollments();
                                        } else {
                                          allEnrollments();
                                        }
                                      },
                                    );
                                  },
                                  checkColor: Colors.white,
                                  side: const BorderSide(color: Colors.white),
                                ),
                                Text(
                                  'My Enrollments Only',
                                  style: SafeGoogleFont(
                                    'Ubuntu',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xffffffff),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: SizedBox(
                    // height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            CustomisedTextField(
                              textEditingController: supervisor_name_controller,
                              hintText: 'Supervisor Name',
                              obscureText: false,
                              width: 150 * fem,
                            ),
                            CustomisedTextField(
                              textEditingController: project_title_controller,
                              hintText: 'Project Title',
                              obscureText: false,
                              width: 150 * fem,
                            ),
                            CustomisedTextField(
                              textEditingController: semester_controller,
                              hintText: 'Semester',
                              obscureText: false,
                              width: 150 * fem,
                            ),
                            CustomisedTextField(
                              textEditingController: year_controller,
                              hintText: 'Year',
                              obscureText: false,
                              width: 150 * fem,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[300],
                                  ),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.search,
                                    ),
                                    iconSize: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // supervisorEnrollments(),
                // allEnrollments(),
                Container(
                  width: 1200 * fem,
                  margin: EdgeInsets.fromLTRB(60, 30, 100 * fem, 0),
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
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: EnrollmentDataTable(
                          enrollments: enrollments,
                          role: widget.role,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 100,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Enrollment {
  final String name, sname1, sname2, sem, year, description, project_id;

  const Enrollment({
    required this.name,
    required this.sname1,
    required this.sname2,
    required this.sem,
    required this.year,
    required this.description,
    required this.project_id,
  });
}
