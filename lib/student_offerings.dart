import 'package:casper/components/confirm_action.dart';
import 'package:casper/components/customised_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'data_tables/shared/offerings_data_table.dart';
import 'components/search_text_field.dart';
import 'models/models.dart';

class StudentOfferings extends StatefulWidget {
  const StudentOfferings({Key? key}) : super(key: key);

  @override
  State<StudentOfferings> createState() => _StudentOfferingsState();
}

class _StudentOfferingsState extends State<StudentOfferings> {
  final supervisorNameController = TextEditingController(),
      projectTitleController = TextEditingController(),
      semesterController = TextEditingController(),
      yearController = TextEditingController();
  var db = FirebaseFirestore.instance;

  String? supervisorName, projectTitle, semester, year;

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

  OfferingsDataTable? offeringsDataTable;

  List<Offering> offerings = [];

  void fill() {
    offerings.clear();
    FirebaseFirestore.instance
        .collection('offerings')
        .where('status', isEqualTo: 'open')
        .get()
        .then((value) async {
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
            if (!project.title.toLowerCase().contains(name.toLowerCase()))
              flag = 0;
          }

          if (semester != null) {
            String semester = this.semester.toString().toLowerCase();
            if (!doc['semester'].toLowerCase().contains(semester)) flag = 0;
          }

          if (year != null) {
            String year = this.year.toString().toLowerCase();
            if (!doc['year'].toLowerCase().contains(year)) flag = 0;
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
          offeringsDataTable = OfferingsDataTable(
            offerings: offerings,
          );
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fill();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = (MediaQuery.of(context).size.width / baseWidth) * 0.97;

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
                  const CustomisedText(
                    text: 'Available Projects',
                    fontSize: 50,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 33 * fem,
                      ),
                      SearchTextField(
                        textEditingController: supervisorNameController,
                        hintText: 'Supervisor Name',
                        width: 180 * fem,
                      ),
                      SizedBox(
                        width: 30 * fem,
                      ),
                      SearchTextField(
                        textEditingController: projectTitleController,
                        hintText: 'Project Title',
                        width: 180 * fem,
                      ),
                      SizedBox(
                        width: 30 * fem,
                      ),
                      SearchTextField(
                        textEditingController: semesterController,
                        hintText: 'Semester',
                        width: 180 * fem,
                      ),
                      SizedBox(
                        width: 30 * fem,
                      ),
                      SearchTextField(
                        textEditingController: yearController,
                        hintText: 'Year',
                        width: 180 * fem,
                      ),
                      SizedBox(
                        width: 50 * fem,
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
                              supervisorName =
                                  supervisorNameController.text.trim() == ''
                                      ? null
                                      : supervisorNameController.text.trim();
                              projectTitle =
                                  projectTitleController.text.trim() == ''
                                      ? null
                                      : projectTitleController.text.trim();
                              semester = semesterController.text.trim() == ''
                                  ? null
                                  : semesterController.text.trim();
                              year = yearController.text.trim() == ''
                                  ? null
                                  : yearController.text.trim();
                            });
                            fill();
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 670,
                    width: 1200 * fem,
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 65),
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
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: offeringsDataTable,
                          ),
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
