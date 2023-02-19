import 'package:casper/utils.dart';
import 'package:casper/components/weektile.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/textfield.dart';
import 'package:casper/components/button.dart';

class ProjectPage extends StatefulWidget {
  final flag;

  ProjectPage({Key? key, this.flag = true}) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  TextEditingController weeklyMarksInputController = TextEditingController();
  TextEditingController weeklyMarksConfirmInputController =
      TextEditingController();

  void uploadWeeklyMarks() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Container(
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Enter Obtained Marks',
                        style: SafeGoogleFont(
                          'Montserrat',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff000000),
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    texteditingcontroller: weeklyMarksInputController,
                    hinttext: 'Marks',
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Confirm Obtained Marks',
                        style: SafeGoogleFont(
                          'Montserrat',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff000000),
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    texteditingcontroller: weeklyMarksConfirmInputController,
                    hinttext: 'Confirm Marks',
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        buttonText: 'Submit',
                        onPressed: () {},
                      ),
                      CustomButton(
                        buttonText: 'Cancel',
                        onPressed: () => {Navigator.pop(context)},
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
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
    if (widget.flag) {
      return Expanded(
        child: Container(
          color: Color(0xff302c42),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: Text(
                      'Fair Clustering Algorithms',
                      style: SafeGoogleFont(
                        'Montserrat',
                        fontSize: 50,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        child: Text(
                          'Dr Shweta Jain - 2023 II',
                          style: SafeGoogleFont(
                            'Montserrat',
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 5),
                            child: Text(
                              'Aman Kumar',
                              style: SafeGoogleFont(
                                'Montserrat',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 5),
                            child: Text(
                              'Ojassvi Kumar',
                              style: SafeGoogleFont(
                                'Montserrat',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  WeekTile(
                    datefrom: '03/01/2023',
                    dateto: '09/01/2023',
                    weekname: 'Week 1',
                    remarks: 'Good!',
                    marksobtained: 'Marks Not Uploaded Yet',
                    flag: false,
                    buttonflag: true,
                    buttonOnPressed: uploadWeeklyMarks,
                    buttontext: 'Add Marks',
                  ),
                  const WeekTile(
                    datefrom: '03/01/2023',
                    dateto: '09/01/2023',
                    weekname: 'Week 2',
                    remarks: 'Good!',
                    marksobtained: '97/100',
                    flag: true,
                  )
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return Expanded(
        child: Container(
          color: Color(0xff302c42),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                'No project found!',
                style: SafeGoogleFont(
                  'Montserrat',
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffffffff),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
