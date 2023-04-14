import 'package:casper/components/customised_text.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/models/models.dart';
import 'package:casper/data_tables/faculty/enrollments_data_table.dart';
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
      studentNameController = TextEditingController(),
      courseCodeController = TextEditingController(text: 'CP302'),
      yearController = TextEditingController(text: '2022'),
      semesterController = TextEditingController(text: '2');

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
          // print(doc.id);
          List<Evaluation> supervisorEvaluations = [];
          Map studentNames = {};
          // print(val['student_name'][0]);
          var temp = List<MapEntry<String, String>>.generate(
              val['student_name'].length,
              (index) => MapEntry(
                  val['student_ids'][index], val['student_name'][index]));
          studentNames.addEntries(temp);
          FirebaseFirestore.instance
              .collection('evaluations')
              .where('project_id', isEqualTo: doc.id)
              .get()
              .then((value) {
            var evaluation_doc = value.docs[0];
            List<String> studentIds =
                evaluation_doc['weekly_evaluations'][0].keys.toList();
            for (String studentId in studentIds) {
              for (int week = 0;
                  week < int.tryParse(evaluation_doc['number_of_evaluations'])!;
                  week++) {
                Evaluation evaluation = Evaluation(
                  id: '1',
                  marks: int.tryParse(
                      evaluation_doc['weekly_evaluations'][week][studentId])!,
                  remarks: evaluation_doc['weekly_comments'][week][studentId],
                  type: 'week-${week + 1}',
                  student: Student(
                      id: studentId,
                      email: '$studentId@iitrpr.ac.in',
                      entryNumber: studentId,
                      name: studentNames[studentId]),
                  faculty: Faculty(
                      id: evaluation_doc['supervisor_id'],
                      name: val['instructor_name'],
                      //TODO: email
                      email: 'temp@iitrpr.ac.iin'),
                );
                supervisorEvaluations.add(evaluation);
              }
            }

            setState(() {
              enrollments.add(
                Enrollment(
                  id: doc.id,
                  offering: Offering(
                    id: val['offering_id'],
                    instructor: Faculty(
                      id: FirebaseAuth.instance.currentUser!.uid,
                      name: val['instructor_name'],
                      email:
                          FirebaseAuth.instance.currentUser!.email.toString(),
                    ),
                    course: val['type'],
                    semester: val['semester'],
                    year: val['year'],
                    project: Project(
                      id: doc.id,
                      title: val['title'],
                      description: val['description'],
                    ),
                  ),
                  team: Team(
                    id: val['team_id'],
                    numberOfMembers: val['student_ids'].length,
                    students: List<Student>.generate(
                      val['student_ids'].length,
                      (index) => Student(
                        id: val['student_ids'][index],
                        name: val['student_name'][index],
                        entryNumber: val['student_ids'][index],
                        email: '${val['student_ids'][index]}@iitrpr.ac.in',
                      ),
                    ),
                  ),
                  supervisorEvaluations: supervisorEvaluations,
                ),
              );
            });
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
                        hintText: 'Project',
                        width: 170 * fem,
                      ),
                      SizedBox(
                        width: 20 * fem,
                      ),
                      SearchTextField(
                        textEditingController: studentNameController,
                        hintText: 'Student\'s Name',
                        width: 170 * fem,
                      ),
                      SizedBox(
                        width: 20 * fem,
                      ),
                      SearchTextField(
                        textEditingController: courseCodeController,
                        hintText: 'Course',
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
