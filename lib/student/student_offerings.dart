import 'package:casper/components/confirm_action.dart';
import 'package:casper/components/customised_text_field.dart';
import 'package:casper/components/projecttile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/customised_text.dart';

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                        child: CustomisedTextField(
                          textEditingController: supervisorNameController,
                          hintText: 'Supervisor Name',
                          obscureText: false,
                          width: 100 * fem,
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                        child: CustomisedTextField(
                          textEditingController: projectTitleController,
                          hintText: 'Project Title',
                          obscureText: false,
                          width: 100 * fem,
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                        child: CustomisedTextField(
                          textEditingController: semesterController,
                          hintText: 'Semester',
                          obscureText: false,
                          width: 100 * fem,
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: CustomisedTextField(
                          textEditingController: yearController,
                          hintText: 'Year',
                          obscureText: false,
                          width: 100 * fem,
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 55,
                        margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
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
                  // StreamBuilder(
                  //   stream: db
                  //       .collection('offerings')
                  //       .where(
                  //         'status',
                  //         isEqualTo: 'open',
                  //       )
                  //       .snapshots(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       return ListView.builder(
                  //         shrinkWrap: true,
                  //         physics: const ClampingScrollPhysics(),
                  //         itemCount: snapshot.data?.docs.length,
                  //         itemBuilder: (context, index) {
                  //           return ProjectTile(
                  //             info:
                  //                 'Supervisor Name - ${snapshot.data?.docs[index]['instructor_name']}\nSemester - ${snapshot.data?.docs[index]['semester']}\nYear - ${snapshot.data?.docs[index]['year']}\nProject Description - ${snapshot.data?.docs[index]['description']}',
                  //             title: '${snapshot.data?.docs[index]['title']}',
                  //             type: '${snapshot.data?.docs[index]['type']}',
                  //             button_flag: true,
                  //             button_onPressed: confirmAction,
                  //             button_text: 'Apply Now',
                  //             status:
                  //                 '(${snapshot.data?.docs[index]['status']})',
                  //             theme: 'w',
                  //           );
                  //         },
                  //       );
                  //     } else {
                  //       return const CustomisedText(text: 'loading...');
                  //     }
                  //   },
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
