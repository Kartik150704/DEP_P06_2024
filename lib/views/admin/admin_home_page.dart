import 'package:casper/components/add_faculty_form.dart';
import 'package:casper/components/add_student_form.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/components/mark_semester_form.dart';
import 'package:casper/components_new/customised_button.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  AdminHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double wfem = (MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio) /
        baseWidth;
    double hfem = (MediaQuery.of(context).size.height *
            MediaQuery.of(context).devicePixelRatio) /
        baseWidth;
    print('im here');
    return Row(
      children: [
        SizedBox(
          width: 300 * wfem,
          child: Scaffold(
            body: Container(
              color: const Color(0xff545161),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      CustomisedButton(
                        width: 222 * wfem,
                        height: 60,
                        text: 'Add Faculty',
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Center(child: AddFacultyForm()),
                                );
                              });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomisedButton(
                        width: 222 * wfem,
                        height: 60,
                        text: 'Add Students',
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Center(child: AddStudentForm()),
                                );
                              });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomisedButton(
                        width: 222 * wfem,
                        height: 60,
                        text: 'Mark Semester',
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Center(child: MarkSemesterForm()),
                                );
                              });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
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
                            text: 'Admin Page',
                            fontSize: 50,
                          ),
                          Container(),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: 1000 * wfem,
                        height: 1000 * hfem,
                        child: const Center(
                          child: SizedBox(
                            width: 500,
                            height: 500,
                            child: Image(
                              image: AssetImage(
                                'assets/images/logo_iitrpr.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 65,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
