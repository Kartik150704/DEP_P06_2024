import 'package:casper/components/add_teams_form.dart';
import 'package:casper/comp/customised_overflow_text.dart';
import 'package:casper/comp/customised_text.dart';
import 'package:casper/data_tables/faculty/faculty_panel_teams_data_table.dart';
import 'package:casper/components/search_text_field.dart';
import 'package:casper/models/models.dart';
import 'package:casper/views/shared/loading_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FacultyPanelTeamsPage extends StatefulWidget {
  final int actionType;
  final String userRole;
  final AssignedPanel assignedPanel;

  const FacultyPanelTeamsPage({
    Key? key,
    required this.actionType,
    required this.userRole,
    required this.assignedPanel,
  }) : super(key: key);

  @override
  State<FacultyPanelTeamsPage> createState() => _FacultyPanelTeamsPageState();
}

class _FacultyPanelTeamsPageState extends State<FacultyPanelTeamsPage> {
  bool loading = true;
  List<Team> assignedTeams = [];
  final teamIdController = TextEditingController(),
      studentNameController = TextEditingController(),
      studentEntryNumberController = TextEditingController();

  void getPanelData() {
    if (widget.assignedPanel.assignedProjectIds!.isEmpty) {
      setState(() {
        loading = false;
      });
      return;
    }
    FirebaseFirestore.instance
        .collection('projects')
        .where(FieldPath.documentId,
            whereIn: widget.assignedPanel.assignedProjectIds)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        print(doc.id);
        List<Student> students = [];
        for (int i = 0; i < doc['student_ids'].length; i++) {
          students.add(Student(
              id: doc['student_ids'][i],
              name: doc['student_name'][i],
              entryNumber: doc['student_ids'][i],
              email: doc['student_ids'][i] + '@iitrpr.ac.in'));
        }
        Team team = Team(
            id: doc['team_id'],
            numberOfMembers: doc['student_ids'].length,
            students: students);
        setState(() {
          assignedTeams.add(team);
        });

        FirebaseFirestore.instance
            .collection('evaluations')
            .where('project_id', isEqualTo: doc.id)
            .get()
            .then(
          (value) {
            List<Evaluation> evals = [];
            for (var doc in value.docs) {
              for (int i = 0;
                  i < widget.assignedPanel.panel.numberOfEvaluators;
                  i++) {
                for (Student student in students) {
                  Evaluation evaluation = Evaluation(
                    id: '1',
                    marks: double.tryParse(
                        doc['midsem_evaluation'][i][student.entryNumber])!,
                    remarks: doc['midsem_panel_comments'][i]
                        [student.entryNumber],
                    type: 'midterm-panel',
                    student: student,
                    faculty: widget.assignedPanel.panel.evaluators[i],
                  );
                  evals.add(evaluation);
                }
              }
              for (int i = 0;
                  i < widget.assignedPanel.panel.numberOfEvaluators;
                  i++) {
                for (Student student in students) {
                  Evaluation evaluation = Evaluation(
                    id: '1',
                    marks: double.tryParse(
                        doc['endsem_evaluation'][i][student.entryNumber])!,
                    remarks: doc['endsem_panel_comments'][i]
                        [student.entryNumber],
                    type: 'endterm-panel',
                    student: student,
                    faculty: widget.assignedPanel.panel.evaluators[i],
                  );
                  evals.add(evaluation);
                }
              }
              for (Student student in students) {
                for (int week = 0;
                    week < int.tryParse(doc['number_of_evaluations'])!;
                    week++) {
                  Evaluation evaluation = Evaluation(
                    id: '1',
                    marks: double.tryParse(
                        doc['weekly_evaluations'][week][student.entryNumber])!,
                    remarks: doc['weekly_comments'][week][student.entryNumber],
                    type: 'week-${week + 1}',
                    student: student,
                    //TODO: add name and email
                    faculty: Faculty(
                        id: doc['supervisor_id'],
                        name: 'temp',
                        email: 'temp@iitrpr.ac.iin'),
                  );
                  evals.add(evaluation);
                }
              }
            }

            setState(() {
              widget.assignedPanel.evaluations.addAll(evals);
            });
          },
        );
        setState(() {
          loading = false;
        });
      }
    });
  }

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
    getPanelData();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double wfem = (MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio) /
        baseWidth;

    if (loading) {
      return const LoadingPage();
    }

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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomisedText(
                          text: 'Panel ${widget.assignedPanel.panel.id}: ',
                          fontSize: 50,
                        ),
                        Container(
                          height: 50,
                          alignment: Alignment.bottomLeft,
                          child: CustomisedOverflowText(
                            text:
                                ' ${widget.assignedPanel.panel.evaluators.map((e) => e.name).join(', ')}',
                            fontSize: 30,
                          ),
                        ),
                        Container(
                          height: 45,
                          alignment: Alignment.bottomRight,
                          child: CustomisedOverflowText(
                            text:
                                '  [${widget.assignedPanel.course}, ${widget.assignedPanel.year}-${widget.assignedPanel.semester}, ${widget.assignedPanel.term}]',
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 33 * wfem,
                        ),
                        SearchTextField(
                          textEditingController: teamIdController,
                          hintText: 'Team Identification',
                          width: 170 * wfem,
                        ),
                        SizedBox(
                          width: 20 * wfem,
                        ),
                        SearchTextField(
                          textEditingController: studentNameController,
                          hintText: 'Student Name',
                          width: 170 * wfem,
                        ),
                        SizedBox(
                          width: 20 * wfem,
                        ),
                        SearchTextField(
                          textEditingController: studentEntryNumberController,
                          hintText: 'Student Entry Number',
                          width: 170 * wfem,
                        ),
                        SizedBox(
                          width: 25 * wfem,
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
                      width: 1200 * wfem,
                      height: 525 * wfem,
                      margin: EdgeInsets.fromLTRB(40, 15, 80 * wfem, 0),
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
                        child: SingleChildScrollView(
                          child: FacultyPanelTeamsDataTable(
                            actionType: widget.actionType,
                            assignedPanel: widget.assignedPanel,
                            assignedTeams: assignedTeams,
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
