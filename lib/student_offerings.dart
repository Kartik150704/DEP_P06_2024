import 'package:casper/components/confirm_action.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/components/customised_text_field.dart';
import 'package:casper/components/offering_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'data_tables/shared/offerings_data_table.dart';
import 'components/search_text_field.dart';

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
                          onPressed: () {},
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
                            child: OfferingsDataTable(),
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
