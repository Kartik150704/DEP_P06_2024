import 'package:casper/components/add_project_form.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/data_tables/shared/offerings_data_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../components/search_text_field.dart';

class FacultyOfferingsPage extends StatefulWidget {
  FacultyOfferingsPage({Key? key}) : super(key: key);

  @override
  State<FacultyOfferingsPage> createState() => _FacultyOfferingsPageState();
}

class _FacultyOfferingsPageState extends State<FacultyOfferingsPage> {
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
            child: AddProjectForm(),
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
      child: Scaffold(
        body: Container(
          color: const Color(0xff302c42),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(60, 30, 0, 0),
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
                      ],
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
                          textEditingController: supervisor_name_controller,
                          hintText: 'Supervisor Name',
                          width: 180 * fem,
                        ),
                        SizedBox(
                          width: 30 * fem,
                        ),
                        SearchTextField(
                          textEditingController: project_title_controller,
                          hintText: 'Project Title',
                          width: 180 * fem,
                        ),
                        SizedBox(
                          width: 30 * fem,
                        ),
                        SearchTextField(
                          textEditingController: semester_controller,
                          hintText: 'Semester',
                          width: 180 * fem,
                        ),
                        SizedBox(
                          width: 30 * fem,
                        ),
                        SearchTextField(
                          textEditingController: year_controller,
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
                      margin: EdgeInsets.fromLTRB(40, 15, 80 * fem, 0),
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
                              //TODO: add the data table here
                              child: OfferingsDataTable(
                                offerings: [],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 7, 0),
              child: Tooltip(
                message: 'Add Project',
                child: FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 212, 203, 216),
                  splashColor: Colors.black,
                  hoverColor: Colors.grey,
                  child: const Icon(
                    Icons.my_library_add,
                    color: Colors.black,
                    size: 35,
                  ),
                  onPressed: () {
                    addProject();
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 65,
            ),
          ],
        ),
      ),
    );
  }
}
