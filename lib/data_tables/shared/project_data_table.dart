import 'package:casper/comp/data_not_found.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/comp/customised_overflow_text.dart';
import 'package:casper/comp/customised_text.dart';
import 'package:casper/components/marks_submission_form.dart';
import 'package:casper/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProjectDataTable extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final enrollment,
      assignedPanels,
      releasedEvents,
      isFaculty,
      evaluation_doc_id;
  var refresh;

  ProjectDataTable({
    super.key,
    required this.enrollment,
    required this.assignedPanels,
    required this.releasedEvents,
    required this.evaluation_doc_id,
    required this.refresh,
    this.isFaculty = false,
  });

  @override
  State<ProjectDataTable> createState() => _ProjectDataTableState();
}

class _ProjectDataTableState extends State<ProjectDataTable> {
  int? sortColumnIndex;
  bool isAscending = false;
  List<EnrollmentData> enrollmentData = [];

  void getEnrollmentData() {
    setState(() {
      enrollmentData.clear();
    });
    for (var evnt in widget.releasedEvents.events) {
      for (var stdnt in widget.enrollment.team.students) {
        bool isEvaluated = false;
        for (Evaluation eval in widget.enrollment.supervisorEvaluations) {
          if (eval.type.contains(evnt.type) && stdnt.id == eval.student.id) {
            isEvaluated = true;
            if (evnt.type == 'midterm' || evnt.type == 'endterm') {
              double marks = 0, count = 0;
              for (var panel in widget.assignedPanels) {
                for (var panelEval in panel.evaluations) {
                  if (panelEval.type.contains(evnt.type) &&
                      stdnt.id == panelEval.student.id) {
                    marks += panelEval.marks;
                    count++;
                  }
                }
              }

              enrollmentData.add(
                EnrollmentData(
                    event: (evnt.type == 'midterm' ? 'MidTerm' : 'EndTerm'),
                    studentName: stdnt.name,
                    studentEntryNumber: stdnt.entryNumber,
                    duration: '${evnt.start} - ${evnt.end}',
                    marks:
                        '${eval.marks} + ${count == 0 ? 'NA' : '${(marks / count).toStringAsFixed(1)} ($count)'}',
                    count: count.toString(),
                    remark: eval.remarks),
              );
            } else {
              enrollmentData.add(
                EnrollmentData(
                    event: (eval.type.contains('week')
                        ? 'Week-${eval.type.substring(5, 6)}'
                        : 'Report'),
                    studentName: stdnt.name,
                    studentEntryNumber: stdnt.entryNumber,
                    duration: '${evnt.start} - ${evnt.end}',
                    marks: eval.marks.toString(),
                    remark: eval.remarks),
              );
            }
          }
        }

        if (!isEvaluated) {
          String eventType = 'Week-${evnt.type.substring(5, 6)}';
          if (evnt.type == 'midterm' || evnt.type == 'endterm') {
            eventType = (evnt.type == 'midterm' ? 'MidTerm' : 'EndTerm');
            double marks = 0, count = 0;
            for (var panel in widget.assignedPanels) {
              for (var panelEval in panel.evaluations) {
                if (panelEval.type.contains(evnt.type) &&
                    stdnt.id == panelEval.student.id) {
                  marks += panelEval.marks;
                  count++;
                }
              }
            }

            enrollmentData.add(
              EnrollmentData(
                  event: (evnt.type == 'midterm' ? 'MidTerm' : 'EndTerm'),
                  studentName: stdnt.name,
                  studentEntryNumber: stdnt.entryNumber,
                  duration: '${evnt.start} - ${evnt.end}',
                  marks:
                      'NA + ${count == 0 ? 'NA' : '${(marks / count).toStringAsFixed(1)} ($count)'}',
                  count: count.toString(),
                  // TODO: panel remarks
                  remark: ''),
            );
            continue;
          } else if (evnt.type == 'report') {
            eventType = 'Report';
          }

          enrollmentData.add(
            EnrollmentData(
                event: eventType,
                studentName: stdnt.name,
                studentEntryNumber: stdnt.entryNumber,
                duration: '${evnt.start} - ${evnt.end}',
                marks: 'NA',
                remark: ''),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.releasedEvents.events.isEmpty) {
      return DataNotFound(message: 'No Events Found');
    } else if (enrollmentData.isEmpty) {
      getEnrollmentData();
    }

    final columns = [
      'Event',
      'Student',
      'Entry Number',
      'Duration',
      'Marks',
      'Action',
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
        rows: getRows(enrollmentData),
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
        label: CustomisedText(
          text: columns[2],
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: CustomisedText(
          text: columns[3],
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: CustomisedText(
          text: columns[4],
        ),
        onSort: onSort,
      ),
      DataColumn(
        label: CustomisedText(
          text: columns[5],
        ),
      ),
    ];
    return headings;
  }

  List<DataRow> getRows(List<EnrollmentData> rows) => rows.map(
        (EnrollmentData data) {
          final cells = [
            DataCell(
              CustomisedText(
                text: data.event,
                color: Colors.black,
              ),
            ),
            DataCell(
              Tooltip(
                message: data.studentName,
                child: SizedBox(
                  width: 165,
                  child: CustomisedOverflowText(
                    text: data.studentName,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            DataCell(
              CustomisedText(
                text: data.studentEntryNumber,
                color: Colors.black,
              ),
            ),
            DataCell(
              CustomisedText(
                text: data.duration,
                color: Colors.black,
              ),
            ),
            DataCell(
              Tooltip(
                message: (data.event == 'MidTerm' || data.event == 'EndTerm'
                    ? 'Supervisor Marks + Average Of Panel Marks ${data.count == '0' ? '' : '(Number Of Evaluations Completed)'}'
                    : ''),
                child: CustomisedText(
                  text: data.marks,
                  color: Colors.black,
                ),
              ),
            ),
            DataCell(
              // TODO: show upload button to only the student who is logged in
              (data.event.contains('Week')
                  ? (data.marks != 'NA' && !widget.isFaculty
                      ? const CustomisedText(
                          text: 'Completed',
                          color: Colors.black,
                        )
                      : CustomisedButton(
                          width: double.infinity,
                          height: 35,
                          text: 'Upload',
                          onPressed: () {
                            TextEditingController marksController =
                                    TextEditingController(
                                        text: data.marks.toString()),
                                remarksController =
                                    TextEditingController(text: data.remark);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Center(
                                    child: MarksSubmissionForm(
                                        marksInputController: marksController,
                                        remarksInputController:
                                            remarksController,
                                        onSubmit: () {
                                          FirebaseFirestore.instance
                                              .collection('evaluations')
                                              .doc(widget.evaluation_doc_id)
                                              .get()
                                              .then((doc) {
                                            int weekNumber = int.parse(
                                                    data.event.split('-')[1]) -
                                                1;
                                            if (doc.exists) {
                                              var weekdata =
                                                  doc['weekly_evaluations']
                                                      [weekNumber];

                                              weekdata[
                                                      data.studentEntryNumber] =
                                                  marksController.text.trim();
                                              doc['weekly_evaluations']
                                                  [weekNumber] = weekdata;
                                              var newWeeklyEvaluations =
                                                  doc['weekly_evaluations'];
                                              newWeeklyEvaluations[weekNumber] =
                                                  weekdata;

                                              var weekComments =
                                                  doc['weekly_comments']
                                                      [weekNumber];
                                              weekComments[
                                                      data.studentEntryNumber] =
                                                  remarksController.text.trim();
                                              var newWeeklyComments =
                                                  doc['weekly_comments'];
                                              newWeeklyComments[weekNumber] =
                                                  weekComments;

                                              doc.reference.update({
                                                'weekly_evaluations':
                                                    newWeeklyEvaluations,
                                                'weekly_comments':
                                                    newWeeklyComments,
                                              }).then((value) {
                                                // widget.refresh();
                                                // setState(() {
                                                //   enrollmentData = [];
                                                // });
                                                // getEnrollmentData();
                                              });
                                            } else {
                                              debugPrint(
                                                  'evaluation key_id doesn\'t exist in database or is wrongly initialised');
                                            }
                                          });
                                          Navigator.pop(context);
                                        },
                                        isFaculty: widget.isFaculty,
                                        status: true),
                                  ),
                                );
                              },
                            );
                          },
                          elevation: 0,
                        ))
                  : const CustomisedText(
                      text: 'Unauthorized',
                      color: Colors.black,
                    )),
            ),
          ];
          return DataRow(
            cells: cells,
            color: MaterialStateProperty.resolveWith(
              (states) {
                if (data.marks.contains('NA')) {
                  return const Color.fromARGB(255, 208, 219, 144);
                } else {
                  return const Color(0xff7ae37b);
                }
              },
            ),
          );
        },
      ).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      enrollmentData.sort(
        (evaluation1, evaluation2) =>
            compareString(ascending, evaluation1.event, evaluation2.event),
      );
    } else if (columnIndex == 1) {
      enrollmentData.sort(
        (evaluation1, evaluation2) => compareString(
            ascending, evaluation1.studentName, evaluation2.studentName),
      );
    } else if (columnIndex == 2) {
      enrollmentData.sort(
        (evaluation1, evaluation2) => compareString(ascending,
            evaluation1.studentEntryNumber, evaluation2.studentEntryNumber),
      );
    } else if (columnIndex == 3) {
      enrollmentData.sort(
        (evaluation1, evaluation2) => compareString(
            ascending, evaluation1.duration, evaluation2.duration),
      );
    } else if (columnIndex == 4) {
      enrollmentData.sort(
        (evaluation1, evaluation2) =>
            compareString(ascending, evaluation1.marks, evaluation2.marks),
      );
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) {
    if (int.tryParse(value1) != null && int.tryParse(value2) != null) {
      return (ascending
          ? int.parse(value1) > int.parse(value2)
              ? 1
              : int.parse(value1) < int.parse(value2)
                  ? -1
                  : 0
          : int.parse(value2) < int.parse(value1)
              ? -1
              : int.parse(value2) > int.parse(value1)
                  ? 1
                  : 0);
    }
    return (ascending ? value1.compareTo(value2) : value2.compareTo(value1));
  }
}

class EnrollmentData {
  final String event,
      studentName,
      studentEntryNumber,
      duration,
      marks,
      count,
      remark;

  EnrollmentData({
    required this.event,
    required this.studentName,
    required this.studentEntryNumber,
    required this.duration,
    required this.marks,
    this.count = '0',
    required this.remark,
  });
}
