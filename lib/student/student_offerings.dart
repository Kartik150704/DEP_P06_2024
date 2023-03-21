import 'package:casper/components/confirm_action.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/components/customised_text_field.dart';
import 'package:casper/components/offering_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      CustomisedTextField(
                        textEditingController: supervisorNameController,
                        hintText: 'Supervisor Name',
                        obscureText: false,
                        width: 150 * fem,
                      ),
                      CustomisedTextField(
                        textEditingController: projectTitleController,
                        hintText: 'Project Title',
                        obscureText: false,
                        width: 150 * fem,
                      ),
                      CustomisedTextField(
                        textEditingController: semesterController,
                        hintText: 'Semester',
                        obscureText: false,
                        width: 150 * fem,
                      ),
                      CustomisedTextField(
                        textEditingController: yearController,
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
                        margin: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                        child: StreamBuilder(
                          stream: db
                              .collection('offerings')
                              .where(
                                'status',
                                isEqualTo: 'open',
                              )
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: snapshot.data?.docs.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 120,
                                          vertical: 15,
                                        ),
                                        child: OfferingTile(
                                          status: '0',
                                          header: snapshot.data?.docs[index]
                                              ['title'],
                                          secondaryHeader: '',
                                          details: [
                                            snapshot.data?.docs[index]
                                                ['instructor_name'],
                                            snapshot.data?.docs[index]
                                                ['semester'],
                                            snapshot.data?.docs[index]['year'],
                                            snapshot.data?.docs[index]
                                                ['description'],
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            } else {
                              return const CustomisedText(text: 'Loading...');
                            }
                          },
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
