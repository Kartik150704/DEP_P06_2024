import 'package:casper/components/add_teams_form.dart';
import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/data_tables/faculty/panel_teams_data_table.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/models/models.dart';
import 'package:flutter/material.dart';

class FacultyPanelPage extends StatefulWidget {
  final int actionType;
  final String userRole;
  final AssignedPanel assignedPanel;

  const FacultyPanelPage({
    Key? key,
    required this.userRole,
    required this.assignedPanel,
    required this.actionType,
  }) : super(key: key);

  @override
  State<FacultyPanelPage> createState() => _FacultyPanelPageState();
}

class _FacultyPanelPageState extends State<FacultyPanelPage> {
  final teamIdController = TextEditingController(),
      studentNameController = TextEditingController(),
      studentEntryNumberController = TextEditingController(),
      courseTermController = TextEditingController(),
      yearSemesterController = TextEditingController();

  void addTeams() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: AddTeamsForm(),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth * 0.97;
    final scrollController = ScrollController();
    return Expanded(
      child: Scaffold(
        body: Container(
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
                        Column(
                          children: [
                            CustomisedText(
                              text: 'Panel ${widget.assignedPanel.panel.id}: ',
                              fontSize: 50,
                            ),
                            Container(
                              width: 1200,
                              height: 50,
                              alignment: Alignment.bottomLeft,
                              child: CustomisedOverflowText(
                                text:
                                    ' ${widget.assignedPanel.panel.evaluators.map((e) => e.name).join(', ')}',
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                        Container(),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 35 * fem,
                        ),
                        SearchTextField(
                          textEditingController: teamIdController,
                          hintText: 'Team Identification',
                          width: 175 * fem,
                        ),
                        SizedBox(
                          width: 20 * fem,
                        ),
                        SearchTextField(
                          textEditingController: teamIdController,
                          hintText: 'Student Name',
                          width: 175 * fem,
                        ),
                        SizedBox(
                          width: 20 * fem,
                        ),
                        SearchTextField(
                          textEditingController: teamIdController,
                          hintText: 'Student Entry Number',
                          width: 175 * fem,
                        ),
                        SizedBox(
                          width: 20 * fem,
                        ),
                        SearchTextField(
                          textEditingController: teamIdController,
                          hintText: 'Course-Term',
                          width: 175 * fem,
                        ),
                        SizedBox(
                          width: 20 * fem,
                        ),
                        SearchTextField(
                          textEditingController: teamIdController,
                          hintText: 'Year-Semester',
                          width: 175 * fem,
                        ),
                        SizedBox(
                          width: 25 * fem,
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
                      width: 1200 * fem,
                      height: 625,
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
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: scrollController,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: scrollController,
                            child: SingleChildScrollView(
                              child: PanelTeamsDataTable(
                                assignedPanel: widget.assignedPanel,
                                actionType: widget.actionType,
                              ),
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
        floatingActionButton: (widget.actionType == 1
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 7, 0),
                    child: Tooltip(
                      message: 'Add Team(s)',
                      child: FloatingActionButton(
                        backgroundColor:
                            const Color.fromARGB(255, 212, 203, 216),
                        splashColor: Colors.black,
                        hoverColor: Colors.grey,
                        onPressed: addTeams,
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 65,
                  ),
                ],
              )
            : Container()),
      ),
    );
  }
}
