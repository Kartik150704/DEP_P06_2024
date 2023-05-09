import 'dart:html';
import 'dart:math';
import 'dart:convert';
import 'package:casper/comp/customised_text.dart';
import 'package:casper/utilities/utilites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/text_field.dart';
import 'package:casper/components/button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:multiselect/multiselect.dart';
import 'package:csv/csv.dart';
import 'dart:io';

import 'package:mutex/mutex.dart';

import '../../models/models.dart';
import '../form_custom_text.dart';

class AddTeamProjCSV extends StatefulWidget {
  const AddTeamProjCSV({
    super.key,
  });

  @override
  State<AddTeamProjCSV> createState() => _AddTeamProjCSVState();
}

class _AddTeamProjCSVState extends State<AddTeamProjCSV> {
  final _formKey = GlobalKey<FormBuilderState>();
  String selectedEvent = '';

  void _onFormSubmitted() async {
    _formKey.currentState?.save();
    if (_formKey.currentState!.validate()) {
      final filePickerState = _formKey.currentState?.fields['file']
          as FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>;
      final formdata = _formKey.currentState?.value;
      final fileValue = filePickerState.value;
      if (fileValue != null && fileValue.isNotEmpty) {
        final file = fileValue.first as PlatformFile;
        final bytes = file.bytes;
        final csvString = utf8.decode(bytes!);
        final csvData = csvString.split('\n');
        print(csvData);
        for (var item in csvData) print(item);
        // Do something with the CSV data
        // ...

        for (int k = 0; k < csvData.length; k++) {
          var temp = csvData[k].split(',');
          for (int j = 0; j < temp.length; j++) {
            temp[j] = temp[j].trim();
          }

          await FirebaseFirestore.instance
              .collection('offerings')
              .where('title', isEqualTo: temp[2])
              .get()
              .then((value) async {
            var projdoc = value.docs[0];
            await FirebaseFirestore.instance
                .collection('team')
                .where('id', isEqualTo: temp[0])
                .get()
                .then((teamDocs) async {
              var teamDoc = teamDocs.docs[0];
              List<Student> students = [];
              for (int i = 0; i < teamDoc['students'].length; i++) {
                String studentId = teamDoc['students'][i];
                await FirebaseFirestore.instance
                    .collection('student')
                    .where('id', isEqualTo: studentId)
                    .get()
                    .then((studentDocs) async {
                  var studentDoc = studentDocs.docs[0];
                  var proj_id = studentDoc['proj_id'];
                  if (projdoc['type'] == 'CP301') {
                    proj_id[0] = projdoc.id;
                  } else if (projdoc['type'] == 'CP302') {
                    proj_id[1] = projdoc['type'];
                  } else if (projdoc['type'] == 'CP303') {
                    proj_id[2] = projdoc['type'];
                  } else if (projdoc['type'] == 'CP304') {
                    proj_id[3] = projdoc['type'];
                  } else if (projdoc['type'] == 'CP305') {
                    proj_id[4] = projdoc['type'];
                  }

                  var updateData = {
                    'proj_id': proj_id,
                  };
                  await FirebaseFirestore.instance
                      .collection('student')
                      .doc(studentDoc.id)
                      .update(updateData);
                });
                var inst_name = '';
                var inst_id = '';
                await FirebaseFirestore.instance
                    .collection('instructors')
                    .where('email', isEqualTo: temp[1])
                    .get()
                    .then((instructorDocs) {
                  var instructorDoc = instructorDocs.docs[0];
                  inst_name = instructorDoc['name'];
                  inst_id = instructorDoc.id;
                });
                await FirebaseFirestore.instance
                    .collection('student')
                    .where('id', isEqualTo: studentId)
                    .get()
                    .then((studentDocs) async {
                  var studentDoc = studentDocs.docs[0];
                  Student student = Student(
                      id: studentId,
                      name: studentDoc['name'],
                      entryNumber: studentId,
                      email: '$studentId@iitrpr.ac.in');
                  students.add(student);
                  if (i == teamDoc['students'].length - 1) {
                    var project = {
                      'chat': [],
                      'description': temp[2],
                      'instructor_name': inst_name,
                      'offering_id': projdoc.id,
                      'panel_ids': [],
                      'semester': projdoc['semester'],
                      'year': projdoc['year'],
                      'student_ids': List.generate(
                          students.length, (index) => students[index].id),
                      'student_name': List.generate(
                          students.length, (index) => students[index].name),
                      'team_id': temp[0],
                      'title': temp[2],
                      'type': projdoc['type'],
                    };
                    await FirebaseFirestore.instance
                        .collection('projects')
                        .add(project)
                        .then((value) async {
                      // add reference to instructor document

                      await FirebaseFirestore.instance
                          .collection('instructors')
                          .where('email', isEqualTo: temp[1])
                          .get()
                          .then((instructorDocs) async {
                        var instructorDoc = instructorDocs.docs[0];
                        List<String> projects = List.generate(
                            instructorDoc['project_as_head_ids'].length,
                            (index) =>
                                instructorDoc['project_as_head_ids'][index]);
                        projects.add(value.id);
                        var updateData = {
                          'project_as_head_ids': projects,
                          'number_of_projects_as_head':
                              projects.length.toString(),
                        };
                        await FirebaseFirestore.instance
                            .collection('instructors')
                            .doc(instructorDoc.id)
                            .update(updateData);
                      });

                      // create evaluation document
                      EvaluationCriteria evaluationCriteria;
                      await FirebaseFirestore.instance
                          .collection('evaluation_criteria')
                          .where('course', isEqualTo: project['course'])
                          .where('semester', isEqualTo: projdoc['semester'])
                          .where('year', isEqualTo: projdoc['year'])
                          .get()
                          .then((evaluationCriteriaDocs) async {
                        var evaluationCriteriaDoc =
                            evaluationCriteriaDocs.docs[0];
                        evaluationCriteria = EvaluationCriteria(
                          id: evaluationCriteriaDoc.id,
                          weeksToConsider: int.parse(
                              evaluationCriteriaDoc['weeksToConsider']),
                          course: evaluationCriteriaDoc['course'],
                          semester: evaluationCriteriaDoc['semester'],
                          year: evaluationCriteriaDoc['year'],
                          numberOfWeeks:
                              int.parse(evaluationCriteriaDoc['numberOfWeeks']),
                          regular: int.parse(evaluationCriteriaDoc['regular']),
                          midtermSupervisor: int.parse(
                              evaluationCriteriaDoc['midtermSupervisor']),
                          midtermPanel:
                              int.parse(evaluationCriteriaDoc['midtermPanel']),
                          endtermSupervisor: int.parse(
                              evaluationCriteriaDoc['endtermSupervisor']),
                          endtermPanel:
                              int.parse(evaluationCriteriaDoc['endtermPanel']),
                          report: int.parse(evaluationCriteriaDoc['report']),
                        );
                        var evaluation = {
                          'assigned_panels': [],
                          'endsem_evaluation': [],
                          'endsem_panel_comments': [],
                          'endsem_supervisor': {},
                          'midsem_evaluation': [],
                          'midsem_panel_comments': [],
                          'midsem_supervisor': {},
                          'number_of_evaluations':
                              evaluationCriteria.numberOfWeeks.toString(),
                          'project_id': value.id,
                          'student_ids': List.generate(
                              students.length, (index) => students[index].id),
                          'student_names': List.generate(
                              students.length, (index) => students[index].name),
                          'supervisor_id': inst_id,
                          'weekly_comments': List.generate(
                              evaluationCriteria.numberOfWeeks,
                              (index) => {for (var e in students) e.id: null}),
                          'weekly_evaluations': List.generate(
                              evaluationCriteria.numberOfWeeks,
                              (index) => {for (var e in students) e.id: null}),
                        };
                        await FirebaseFirestore.instance
                            .collection('evaluations')
                            .add(evaluation);
                      });
                    });
                  }
                });
              }
            });
          });
        }
      }
    }
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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            width: 400,
            child: CustomisedText(
              text:
                  'Format: \n TeamId, Instructor Email, Project Title, Course\n ...',
              color: Colors.black,
              fontSize: 23,
            ),
          ),
          Container(
            width: 200,
            height: 125,
            child: FormBuilderFilePicker(
              name: 'file',
              maxFiles: 1,
              validator: FormBuilderValidators.required(errorText: 'Required'),
              allowedExtensions: const ['csv'],
              typeSelectors: [
                TypeSelector(
                  type: FileType.custom,
                  selector: Row(
                    children: const <Widget>[
                      Icon(Icons.add_circle),
                      Padding(
                        padding: EdgeInsets.only(left: 35),
                        child: Text("Upload CSV"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                buttonText: 'Submit',
                onPressed: () => {
                  _onFormSubmitted(),
                  Navigator.pop(context),
                },
              ),
              CustomButton(
                buttonText: 'Cancel',
                onPressed: () => {
                  Navigator.pop(context),
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
