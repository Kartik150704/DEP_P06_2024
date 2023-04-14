import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/models/models.dart';
import 'package:casper/seeds.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EnrollmentsDataTable extends StatefulWidget {
  final List<Enrollment> enrollments;
  final String userRole;

  // ignore: prefer_typing_uninitialized_variables
  final showProject;

  const EnrollmentsDataTable({
    super.key,
    required this.enrollments,
    required this.userRole,
    required this.showProject,
  });

  @override
  State<EnrollmentsDataTable> createState() => _EnrollmentsDataTableState();
}

class _EnrollmentsDataTableState extends State<EnrollmentsDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;

  final int totalWeekly = evaluationCriteriasGLOBAL[0].regular,
      totalMidterm = evaluationCriteriasGLOBAL[0].midtermSupervisor,
      totalMidtermPanel = evaluationCriteriasGLOBAL[0].midtermPanel,
      totalEndterm = evaluationCriteriasGLOBAL[0].endtermSupervisor,
      totalEndtermPanel = evaluationCriteriasGLOBAL[0].endtermPanel,
      totalReport = evaluationCriteriasGLOBAL[0].report;
  late List<StudentData> studentData = [];
  late List<AssignedPanel> assignedPanels = [];

  void getStudentData() {
    setState(() {
      studentData = [];
    });

    for (final enrollment in widget.enrollments) {
      for (final student in enrollment.team.students) {
        int weekly = -1,
            weekCount = 0,
            midterm = -1,
            midtermPanel = -1,
            midtermPanelCount = 0,
            endterm = -1,
            endtermPanel = -1,
            endtermPanelCount = 0,
            report = -1;
        String grade = 'NA';
        for (final panel in assignedPanels) {
          for (final team in panel.assignedTeams) {
            if (team.id == enrollment.team.id) {
              for (final evaluation in panel.evaluations) {
                if (evaluation.student.id == student.id) {
                  if (evaluation.type == 'midterm-panel') {
                    midtermPanelCount += 1;
                    if (midtermPanel == -1) {
                      midtermPanel = evaluation.marks;
                    } else {
                      midtermPanel += evaluation.marks;
                    }
                  } else if (evaluation.type == 'endterm-panel') {
                    endtermPanelCount += 1;
                    if (endtermPanel == -1) {
                      endtermPanel = evaluation.marks;
                    } else {
                      endtermPanel += evaluation.marks;
                    }
                  }
                }
              }
            }
          }
        }

        for (final evaluation in enrollment.supervisorEvaluations) {
          if (evaluation.student.id == student.id) {
            if (evaluation.type == 'midterm-supervisor') {
              midterm = evaluation.marks;
            } else if (evaluation.type == 'endterm-supervisor') {
              endterm = evaluation.marks;
            } else if (evaluation.type.contains('week')) {
              weekCount += 1;
              if (weekly == -1) {
                weekly = evaluation.marks;
              } else {
                weekly += evaluation.marks;
              }
            } else if (evaluation.type == 'report') {
              report = evaluation.marks;
            } else if (evaluation.type.contains('grade')) {
              grade = evaluation.type.split('_')[1];
            }
          }
        }

        studentData.add(
          StudentData(
            weekly: (weekCount == 0 ? -1 : (weekly / weekCount).round()),
            weekCount: weekCount,
            midterm: midterm,
            midtermPanel: (midtermPanelCount == 0
                ? -1
                : (midtermPanel / midtermPanelCount).round()),
            midtermPanelCount: midtermPanelCount,
            endterm: endterm,
            endtermPanel: (endtermPanelCount == 0
                ? -1
                : (endtermPanel / endtermPanelCount).round()),
            endtermPanelCount: endtermPanelCount,
            report: report,
            grade: grade,
            projectId: enrollment.id,
            projectTitle: enrollment.offering.project.title,
            teamId: enrollment.team.id,
            type:
                '${enrollment.offering.course}-${enrollment.offering.year}-${enrollment.offering.semester}',
            student: student,
          ),
        );
      }
    }
  }

  void initializeEvaluations() {
    for (int i = 0; i < assignedPanels.length; i++) {
      AssignedPanel assignedPanel = assignedPanels[i];

      FirebaseFirestore.instance
          .collection('evaluations')
          .where('project_id', whereIn: assignedPanel.assignedProjectIds)
          .get()
          .then((value) {
        List<Evaluation> evals = [];
        for (var doc in value.docs) {
          List<Student> students = [];
          for (int j = 0; j < doc['student_ids'].length; j++) {
            students.add(Student(
                id: doc['student_ids'][j],
                name: doc['student_names'][j],
                entryNumber: doc['student_ids'][j],
                email: doc['student_ids'][j] + '@iitrpr.ac.in'));
          }
          // midsem-panel
          for (int i = 0; i < assignedPanel.panel.numberOfEvaluators; i++) {
            for (Student student in students) {
              Evaluation evaluation = Evaluation(
                id: '1',
                marks: int.tryParse(
                    doc['midsem_evaluation'][i][student.entryNumber])!,
                remarks: doc['midsem_panel_comments'][i][student.entryNumber],
                type: 'midterm-panel',
                student: student,
                faculty: assignedPanel.panel.evaluators[i],
              );
              evals.add(evaluation);
            }
          }
          // endsem-panel
          for (int i = 0; i < assignedPanel.panel.numberOfEvaluators; i++) {
            for (Student student in students) {
              Evaluation evaluation = Evaluation(
                id: '1',
                marks: int.tryParse(
                    doc['endsem_evaluation'][i][student.entryNumber])!,
                remarks: doc['endsem_panel_comments'][i][student.entryNumber],
                type: 'endterm-panel',
                student: student,
                faculty: assignedPanel.panel.evaluators[i],
              );
              evals.add(evaluation);
            }
          }
          // weekly
          for (Student student in students) {
            for (int week = 0;
                week < int.tryParse(doc['number_of_evaluations'])!;
                week++) {
              Evaluation evaluation = Evaluation(
                id: '1',
                marks: int.tryParse(
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

        assignedPanel.evaluations.addAll(evals);
      });
      assignedPanels[i] = assignedPanel;
    }
    getStudentData();
  }

  void initializeTeams() {
    for (int i = 0; i < assignedPanels.length; i++) {
      AssignedPanel assignedPanel = assignedPanels[i];
      FirebaseFirestore.instance
          .collection('projects')
          .where(FieldPath.documentId,
              whereIn: assignedPanel.assignedProjectIds)
          .get()
          .then((value) {
        for (final doc in value.docs) {
          // one project
          List<Student> students = [];
          for (int j = 0; j < doc['student_ids'].length; j++) {
            students.add(Student(
                id: doc['student_ids'][j],
                name: doc['student_name'][j],
                entryNumber: doc['student_ids'][j],
                email: doc['student_ids'][j] + '@iitrpr.ac.in'));
          }
          Team team = Team(
              id: doc['team_id'],
              numberOfMembers: doc['student_ids'].length,
              students: students);
          assignedPanel.assignedTeams.add(team);
        }
        assignedPanels[i] = assignedPanel;
      });
    }
    initializeEvaluations();
  }

  void getPanels() {
    setState(() {
      assignedPanels.clear();
    });
    FirebaseFirestore.instance.collection('assigned_panel').get().then((value) {
      for (var doc in value.docs) {
        setState(() {
          assignedPanels.add(
            AssignedPanel(
              id: doc['panel_id'],
              course: doc['course'],
              term: doc['term'],
              semester: doc['semester'],
              year: doc['year'],
              numberOfAssignedTeams: 0,
              panel: Panel(
                  course: doc['course'],
                  semester: doc['semester'],
                  year: doc['year'],
                  id: doc['panel_id'],
                  numberOfEvaluators: int.parse(doc['number_of_evaluators']),
                  evaluators: List<Faculty>.generate(
                      int.parse(doc['number_of_evaluators']),
                      (index) => Faculty(
                          id: doc['evaluator_ids'][index],
                          name: doc['evaluator_names'][index],
                          email: ''))),
              assignedTeams: [],
              evaluations: [],
              assignedProjectIds:
                  List<String>.from(doc['assigned_project_ids']),
              numberOfAssignedProjects:
                  int.tryParse(doc['number_of_assigned_projects']),
            ),
          );
        });
      }
      initializeTeams();
    });
  }

  @override
  void initState() {
    super.initState();
    getPanels();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enrollments.isEmpty) {
      return SizedBox(
        height: 560,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.grey[300],
                size: 50,
              ),
              const SizedBox(
                width: 10,
              ),
              CustomisedText(
                text: 'No Enrollments found',
                color: Colors.grey[300],
                fontSize: 30,
              ),
            ],
          ),
        ),
      );
    } else if (studentData.isEmpty) {
      getStudentData();
    }

    final columns = [
      'Project',
      'Student',
      'W (${totalWeekly.toString()})',
      'M (${totalMidterm.toString()}+${totalMidtermPanel.toString()})',
      'E (${totalEndterm.toString()}+${totalEndtermPanel.toString()})',
      'R (${totalReport.toString()})',
      'G',
    ];

    return Theme(
      data: Theme.of(context).copyWith(
          iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white)),
      child: DataTable(
        border: TableBorder.all(
          width: 2,
          borderRadius: BorderRadius.circular(2),
          color: const Color.fromARGB(255, 43, 40, 40),
        ),
        sortAscending: isAscending,
        sortColumnIndex: sortColumnIndex,
        columns: getColumns(columns),
        rows: getRows(studentData),
        headingRowColor: MaterialStateColor.resolveWith(
          (states) {
            return const Color(0xff12141D);
          },
        ),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    var headings = [
      DataColumn(
        label: CustomisedText(
          text: columns[0],
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: CustomisedText(
          text: columns[1],
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: Tooltip(
          message: 'Weekly Evaluations Weightage',
          child: CustomisedText(
            text: columns[2],
          ),
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: Tooltip(
          message: 'Midterm Weightage (Supervisor + Panel)',
          child: CustomisedText(
            text: columns[3],
          ),
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: Tooltip(
          message: 'Endterm Weightage (Supervisor + Panel)',
          child: CustomisedText(
            text: columns[4],
          ),
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: Tooltip(
          message: 'Report Weightage',
          child: CustomisedText(
            text: columns[5],
          ),
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: Tooltip(
          message: 'Grade Assigned',
          child: CustomisedText(
            text: columns[6],
          ),
        ),
        onSort: onSort,
      ),
    ];

    return headings;
  }

  List<DataRow> getRows(List<StudentData> rows) => rows.map(
        (StudentData data) {
          final cells = [
            DataCell(
              Container(
                width: 170,
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => widget.showProject(
                    data.projectId,
                  ),
                  child: CustomisedOverflowText(
                    text: data.projectTitle,
                    color: Colors.blue[900],
                    selectable: false,
                  ),
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 140,
                child: CustomisedOverflowText(
                  text: data.student.name,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              Tooltip(
                message: (data.weekCount == 0
                    ? 'No Evaluations Completed'
                    : 'Average Marks Obtained Over ${data.weekCount.toString()} Weeks'),
                child: CustomisedText(
                  text: (data.weekly == -1
                      ? 'NA'
                      : '${data.weekly.toString()} (${data.weekCount.toString()})'),
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              Tooltip(
                message:
                    '${data.midterm == -1 ? 'Supervisor Evaluation Not Completed' : 'Supervisor Evaluation'} + ${data.midtermPanel == -1 ? 'No Panel Evaluation Completed' : 'Average Of ${data.midtermPanelCount} Panel Evaluators'}',
                child: CustomisedText(
                  text:
                      '${data.midterm == -1 ? 'NA' : data.midterm.toString()} + ${data.midtermPanel == -1 ? 'NA' : '${data.midtermPanel.toString()} (${data.midtermPanelCount})'}',
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              Tooltip(
                message:
                    '${data.endterm == -1 ? 'Supervisor Evaluation Not Completed' : 'Supervisor Evaluation'} + ${data.endtermPanel == -1 ? 'No Panel Evaluation Completed' : 'Average Of ${data.endtermPanelCount} Panel Evaluators'}',
                child: CustomisedText(
                  text:
                      '${data.endterm == -1 ? 'NA' : data.endterm.toString()} + ${data.endtermPanel == -1 ? 'NA' : '${data.endtermPanel.toString()} (${data.endtermPanelCount})'}',
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              CustomisedText(
                text:
                    (data.report == -1 ? 'NA' : '${data.report}/$totalReport'),
                color: Colors.black,
              ),
            ),
            DataCell(
              SizedBox(
                child: CustomisedText(
                  text: data.grade,
                  color: Colors.black,
                ),
              ),
            ),
          ];

          return DataRow(
            cells: cells,
            color: MaterialStateProperty.all(
              const Color.fromARGB(255, 212, 203, 216),
            ),
          );
        },
      ).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      studentData.sort(
        (data1, data2) =>
            compareString(ascending, data1.projectTitle, data2.projectTitle),
      );
    } else if (columnIndex == 1) {
      studentData.sort(
        (data1, data2) =>
            compareString(ascending, data1.student.name, data2.student.name),
      );
    } else if (columnIndex == 2) {
      studentData.sort(
        (data1, data2) => compareString(
            ascending, data1.weekly.toString(), data2.weekly.toString()),
      );
    } else if (columnIndex == 3) {
      studentData.sort(
        (data1, data2) => compareString(
            ascending, data1.midterm.toString(), data2.midterm.toString()),
      );
    } else if (columnIndex == 4) {
      studentData.sort(
        (data1, data2) => compareString(
            ascending, data1.endterm.toString(), data2.endterm.toString()),
      );
    } else if (columnIndex == 5) {
      studentData.sort(
        (data1, data2) => compareString(
            ascending, data1.report.toString(), data2.report.toString()),
      );
    } else if (columnIndex == 6) {
      studentData.sort(
        (data1, data2) => compareString(ascending, data1.grade, data2.grade),
      );
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      (ascending ? value1.compareTo(value2) : value2.compareTo(value1));
}

class StudentData {
  final int weekly,
      weekCount,
      midterm,
      midtermPanel,
      midtermPanelCount,
      endterm,
      endtermPanel,
      endtermPanelCount,
      report;
  final String projectTitle, teamId, projectId, type, grade;
  final Student student;

  StudentData({
    required this.weekly,
    required this.weekCount,
    required this.midterm,
    required this.midtermPanel,
    required this.midtermPanelCount,
    required this.endterm,
    required this.endtermPanel,
    required this.endtermPanelCount,
    required this.report,
    required this.grade,
    required this.projectTitle,
    required this.teamId,
    required this.projectId,
    required this.type,
    required this.student,
  });
}