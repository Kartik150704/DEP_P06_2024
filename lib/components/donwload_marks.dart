import 'package:casper/components/customised_text.dart';
import 'package:casper/components_new/customised_button.dart';
import 'package:casper/components_new/form_custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class DownloadMarksForm extends StatefulWidget {
  DownloadMarksForm({
    super.key,
  });

  @override
  State<DownloadMarksForm> createState() => _DownloadMarksFormState();
}

class _DownloadMarksFormState extends State<DownloadMarksForm> {
  int status = 0;
  final _formKey = GlobalKey<FormBuilderState>();
  String semester = '', year = '';

  InputDecoration getDecoration(String hintText) {
    return InputDecoration(
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
    );
  }

  void getSession() {
    FirebaseFirestore.instance
        .collection('current_session')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        var doc = value.docs[0];
        setState(() {
          semester = doc['semester'];
          year = doc['year'];
        });
      } else {
        setState(() {
          semester = '';
          year = '';
        });
      }
    });
  }

  String? integerValidator(
      String? value, String fieldName, int lowerLimit, int higherLimit) {
    if (value == null) {
      return 'enter a valid $fieldName';
    }
    int? val = int.tryParse(value);
    if (val == null) {
      return 'enter a valid $fieldName';
    } else if (val > higherLimit || val < lowerLimit) {
      return 'enter a valid $fieldName';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    if (status == 1 || semester == '' || year == '') {
      return const SizedBox(
        width: 450,
        height: 150,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ),
      );
    } else if (status == 2) {
      return const FormCustomText(text: 'Project added successfully');
    } else if (status == 3) {
      return const FormCustomText(text: 'Criteria not found');
    }

    List<String> vals = [];
    return SizedBox(
      height: 300,
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            const CustomisedText(
              text: 'Semester',
              color: Color(0xff000000),
            ),
            FormBuilderTextField(
              name: 'semester',
              validator: (value) => integerValidator(value, 'semester', 1, 2),
              initialValue: semester,
              enabled: false,
            ),
            const SizedBox(
              height: 10,
            ),
            const CustomisedText(
              text: 'Year',
              color: Color(0xff000000),
            ),
            FormBuilderTextField(
              name: 'year',
              validator: (value) => integerValidator(value, 'year', 2000, 2100),
              initialValue: year,
              enabled: false,
            ),
            const SizedBox(
              height: 10,
            ),
            const CustomisedText(
              text: 'Select the course',
              color: Colors.black,
            ),
            FormBuilderDropdown(
              name: 'type',
              validator: (value) {
                if (value == null) {
                  return 'Please select a course';
                }
                return null;
              },
              items: List<String>.generate(3, (index) => 'CP30${index + 1}')
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomisedButton(
                  width: 70,
                  height: 50,
                  text: 'Submit',
                  onPressed: () async {
                    _formKey.currentState?.save();
                    if (_formKey.currentState!.validate()) {
                      var criteria = null;
                      var data = _formKey.currentState?.value;
                      String course = data!['type'];
                      // print(course + '******');
                      await FirebaseFirestore.instance
                          .collection('evaluation_criteria')
                          .where('semester', isEqualTo: semester)
                          .where('year', isEqualTo: year)
                          .where('course', isEqualTo: data['type'])
                          .get()
                          .then((value) {
                        if (value.docs.isNotEmpty) {
                          var doc = value.docs[0];
                          criteria = doc.data();
                        } else {
                          setState(() {
                            status = 3;
                          });
                        }
                      });

                      if (criteria == null) {
                        return;
                      }

                      int numberOfWeeks = int.parse(criteria['numberOfWeeks']),
                          weeksToConsider =
                              int.parse(criteria['weeksToConsider']);
                      List<dynamic> headings = [
                        'Roll Number',
                        'Team ID',
                        'Name',
                      ];
                      List<dynamic> weekHead = List<dynamic>.generate(
                          numberOfWeeks, (index) => 'Week ${index + 1}');

                      List<dynamic> lastHead = [
                        'Average Regular Marks',
                        'Count',
                        'Best $weeksToConsider',
                        'MidSem Supervisor',
                        'Midsem Panel',
                        'Endsem Supervisor',
                        'Endsem Panel',
                      ];

                      List<dynamic> combinedHead = headings;
                      combinedHead.addAll(weekHead);
                      combinedHead.addAll(lastHead);

                      List<List<dynamic>> rows = [combinedHead];

                      await FirebaseFirestore.instance
                          .collection('projects')
                          .where('semester', isEqualTo: semester)
                          .where('year', isEqualTo: year)
                          .where('type', isEqualTo: course)
                          .get()
                          .then((projectValue) async {
                        for (var doc in projectValue.docs) {
                          print(doc.id);
                          List<String> students =
                              doc['student_ids'].cast<String>();
                          String team_id = doc['team_id'];

                          await FirebaseFirestore.instance
                              .collection('evaluations')
                              .where('project_id', isEqualTo: doc.id)
                              .get()
                              .then((projectValue) {
                            doc = projectValue.docs[0];
                          });

                          for (int i = 0; i < students.length; i++) {
                            var student = students[i];
                            List<dynamic> initialVals = [
                              student,
                              team_id,
                              doc['student_names'][i]
                            ];
                            List<dynamic> weeklyMarks = List<dynamic>.generate(
                                numberOfWeeks,
                                (index) =>
                                    doc['weekly_evaluations'][index][student] ??
                                    '');

                            double average = 0, bestN = 0;
                            int count = 0;

                            for (int j = 0; j < numberOfWeeks; j++) {
                              if (doc['weekly_evaluations'][j][student] !=
                                  null) {
                                count++;
                                average += double.parse(
                                    doc['weekly_evaluations'][j][student]);
                              }
                            }
                            average /= count;
                            List<double> weeklyMarksDouble = weeklyMarks
                                .map((e) => double.tryParse(e) ?? 0.0)
                                .toList();
                            weeklyMarksDouble.sort();
                            for (int j = 0; j < weeksToConsider; j++) {
                              bestN += weeklyMarksDouble[numberOfWeeks - j - 1];
                            }
                            bestN /= weeksToConsider;

                            String midsemSupervisor = '', endsemSupervisor = '';

                            if (doc['midsem_supervisor'][student] != null) {
                              midsemSupervisor =
                                  doc['midsem_supervisor'][student];
                            }
                            if (doc['endsem_supervisor'][student] != null) {
                              endsemSupervisor =
                                  doc['endsem_supervisor'][student];
                            }
                            double midsemPanel = 0, endsemPanel = 0;

                            for (int j = 0;
                                j < doc['midsem_evaluation'].length;
                                j++) {
                              if (doc['midsem_evaluation'][j][student] !=
                                  null) {
                                midsemPanel += double.parse(
                                        doc['midsem_evaluation'][j][student]) /
                                    doc['midsem_evaluation'].length;
                              }
                            }
                            for (int j = 0;
                                j < doc['endsem_evaluation'].length;
                                j++) {
                              if (doc['endsem_evaluation'][j][student] !=
                                  null) {
                                endsemPanel += double.parse(
                                        doc['endsem_evaluation'][j][student]) /
                                    doc['endsem_evaluation'].length;
                              }
                            }
                            String report = '';
                            if (doc['report'] != null &&
                                doc['report'][student] != null) {
                              report = doc['report'][student];
                            }

                            List<dynamic> lastVals = [
                              average.toStringAsFixed(2),
                              count,
                              bestN.toStringAsFixed(2),
                              midsemSupervisor,
                              midsemPanel.toStringAsFixed(2),
                              endsemSupervisor,
                              endsemPanel.toStringAsFixed(2),
                            ];

                            var curRow = [];
                            curRow.addAll(initialVals);
                            curRow.addAll(weeklyMarks);
                            curRow.addAll(lastVals);
                            rows.add(curRow);
                          }
                        }
                      });

                      String csv = const ListToCsvConverter().convert(rows);
                      html.AnchorElement? downloadLink = html.document
                          .createElement('a') as html.AnchorElement?;
                      downloadLink!.href = 'data:text/csv;charset=utf-8,' +
                          Uri.encodeComponent(csv);
                      downloadLink.download =
                          'marks_${course}_$year-$semester.csv';
                      html.document.body!.append(downloadLink);
                      downloadLink.click();
                      downloadLink.remove();
                    }
                  },
                ),
                CustomisedButton(
                  width: 70,
                  height: 50,
                  text: 'Cancel',
                  onPressed: () => {
                    Navigator.pop(context),
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
