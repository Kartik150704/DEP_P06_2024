import 'package:casper/components/add_project_form.dart';
import 'package:casper/components/button.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/components/customised_text_field.dart';
import 'package:casper/components/projecttile.dart';
import 'package:casper/utilites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/text_field.dart';

class OfferingsPageFaculty extends StatefulWidget {
  OfferingsPageFaculty({Key? key}) : super(key: key);

  @override
  State<OfferingsPageFaculty> createState() => _OfferingsPageFacultyState();
}

class _OfferingsPageFacultyState extends State<OfferingsPageFaculty> {
  final semester_controller = TextEditingController(),
      year_controller = TextEditingController(),
      supervisor_name_controller = TextEditingController(),
      project_title_controller = TextEditingController();

  final projectNameController = TextEditingController(),
      projectSemesterController = TextEditingController(),
      projectYearController = TextEditingController(),
      projectDescriptionController = TextEditingController();

  void addProject() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: AddProjectForm(
              projectNameController: projectNameController,
              projectSemesterController: projectSemesterController,
              projectYearController: projectYearController,
              projectDescriptionController: projectDescriptionController,
              onSubmit: () {},
            ),
          ),
        );
      },
    );
  }

  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth * 0.97;
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
                  Row(
                    children: [
                      const CustomisedText(
                        text: 'Projects',
                        fontSize: 50,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(668 * fem, 20.0, 8.0, 8.0),
                        child: CustomButton(
                          buttonText: 'Add Project',
                          onPressed: addProject,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                      SizedBox(
                        height: 50,
                        width: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 158, 157, 168),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => {},
                          child: const Icon(
                            Icons.search,
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 670,
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
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            StreamBuilder(
                              stream: db
                                  .collection('offerings')
                                  .where('status', isEqualTo: 'open')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: snapshot.data?.docs.length,
                                    itemBuilder: (context, index) {
                                      return ProjectTile(
                                        info:
                                            'Supervisor Name - ${snapshot.data?.docs[index]['instructor_name']}\nSemester - ${snapshot.data?.docs[index]['semester']}\nYear - ${snapshot.data?.docs[index]['year']}\nProject Description - ${snapshot.data?.docs[index]['description']}',
                                        title:
                                            '${snapshot.data?.docs[index]['title']}',
                                        type:
                                            '${snapshot.data?.docs[index]['type']}',
                                        theme: 'w',
                                      );
                                    },
                                  );
                                } else {
                                  return const CustomisedText(
                                      text: 'loading...');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
