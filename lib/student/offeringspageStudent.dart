import 'package:casper/components/confirm_action.dart';
import 'package:casper/components/projecttile.dart';
import 'package:casper/utilites.dart';
import 'package:casper/components/weektile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/customised_text.dart';
import '../components/text_field.dart';

class OfferingsPageStudent extends StatefulWidget {
  OfferingsPageStudent({Key? key}) : super(key: key);

  @override
  State<OfferingsPageStudent> createState() => _OfferingsPageStudentState();
}

class _OfferingsPageStudentState extends State<OfferingsPageStudent> {
  final semester_controller = TextEditingController(),
      year_controller = TextEditingController(),
      supervisor_name_controller = TextEditingController(),
      project_title_controller = TextEditingController();

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

  var db = FirebaseFirestore.instance;

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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Text(
                    'Projects',
                    style: SafeGoogleFont(
                      'Ubuntu',
                      fontSize: 50,
                      fontWeight: FontWeight.w700,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextField(
                                  hinttext: 'Semester',
                                  texteditingcontroller: semester_controller,
                                ),
                                CustomTextField(
                                  hinttext: 'Year',
                                  texteditingcontroller: year_controller,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextField(
                                  hinttext: 'Supervisor Name',
                                  texteditingcontroller:
                                      supervisor_name_controller,
                                ),
                                CustomTextField(
                                  hinttext: 'Project Title',
                                  texteditingcontroller:
                                      project_title_controller,
                                ),
                              ],
                            ),
                          ),
                        ),
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
                ),
                StreamBuilder(
                  stream: db
                      .collection('offerings')
                      .where('status', isEqualTo: 'open')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          return ProjectTile(
                            info:
                                'Supervisor Name - ${snapshot.data?.docs[index]['instructor_name']}\nSemester - ${snapshot.data?.docs[index]['semester']}\nYear - ${snapshot.data?.docs[index]['year']}\nProject Description - ${snapshot.data?.docs[index]['description']}',
                            title: '${snapshot.data?.docs[index]['title']}',
                            type: '${snapshot.data?.docs[index]['type']}',
                            button_flag: true,
                            button_onPressed: confirmAction,
                            button_text: 'Apply Now',
                            status: '(${snapshot.data?.docs[index]['status']})',
                            theme: 'w',
                          );
                        },
                      );
                    } else {
                      return const CustomisedText(text: 'loading...');
                    }
                  },
                ),
                const SizedBox(
                  height: 60,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
