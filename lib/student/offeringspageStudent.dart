import 'package:casper/components/confirm_action.dart';
import 'package:casper/components/projecttile.dart';
import 'package:casper/utils.dart';
import 'package:casper/components/weektile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/textfield.dart';

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
                      'Montserrat',
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
                                  hinttext: 'Semeseter',
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
                ProjectTile(
                  info:
                      'Supervisor Name - NAME\nSemester - SEMESTER\nYear - YEAR\nProject Description - DESCRIPTION',
                  title: 'Project Title',
                  type: 'CP303',
                  button_flag: true,
                  button_onPressed: confirmAction,
                  button_text: 'Apply Now',
                  status: '(Offering)',
                  theme: 'w',
                ),
                ProjectTile(
                  info:
                      'Supervisor Name - NAME\nSemester - SEMESTER\nYear - YEAR\nProject Description - DESCRIPTION',
                  title: 'Project Title',
                  type: 'CP303',
                  status: '(Closed)',
                  theme: 'o',
                ),
                ProjectTile(
                  info:
                      'Supervisor Name - NAME\nSemester - SEMESTER\nYear - YEAR\nProject Description - DESCRIPTION',
                  title: 'Project Title',
                  type: 'CP303',
                  button_flag: true,
                  button_onPressed: confirmAction,
                  button_text: 'Apply Now',
                  status: '(Offering)',
                  theme: 'w',
                ),
                SizedBox(
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
