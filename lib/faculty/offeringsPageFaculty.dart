import 'package:casper/components/add_project_form.dart';
import 'package:casper/components/button.dart';
import 'package:casper/components/projecttile.dart';
import 'package:casper/utilites.dart';
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
                    // height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                            width: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomButton(
                                  buttonText: 'Add Project',
                                  onPressed: addProject,
                                ),
                              ),
                            ],
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
                  theme: 'w',
                ),
                ProjectTile(
                  info:
                      'Supervisor Name - NAME\nSemester - SEMESTER\nYear - YEAR\nProject Description - DESCRIPTION',
                  title: 'Project Title',
                  type: 'CP303',
                  theme: 'w',
                ),
                ProjectTile(
                  info:
                      'Supervisor Name - NAME\nSemester - SEMESTER\nYear - YEAR\nProject Description - DESCRIPTION',
                  title: 'Project Title',
                  type: 'CP303',
                  theme: 'w',
                ),
                ProjectTile(
                  info:
                      'Supervisor Name - NAME\nSemester - SEMESTER\nYear - YEAR\nProject Description - DESCRIPTION',
                  title: 'Project Title',
                  type: 'CP303',
                  theme: 'w',
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
