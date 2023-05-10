import 'dart:math';
import 'dart:convert';
import 'package:casper/comp/customised_text.dart';
import 'package:casper/components/form_custom_text.dart';
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

class AssignTeamsToPanelsFromCSVForm extends StatefulWidget {
  const AssignTeamsToPanelsFromCSVForm({
    super.key,
  });

  @override
  State<AssignTeamsToPanelsFromCSVForm> createState() =>
      _AssignTeamsToPanelsFromCSVFormState();
}

class _AssignTeamsToPanelsFromCSVFormState
    extends State<AssignTeamsToPanelsFromCSVForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<String> csvData = [];
  String currentSemester = '', currentYear = '';

  void getSession() {
    FirebaseFirestore.instance
        .collection('current_session')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        var doc = value.docs[0];
        setState(() {
          currentSemester = doc['semester'];
          currentYear = doc['year'];
        });
      } else {
        print(
            'assign_teams_to_panels_from_CSV_form.dart: No current session found');
      }
    });
  }

  Future<void> _onFormSubmitted() async {
    _formKey.currentState?.save();
    if (currentSemester == '' || currentYear == '') {
      return;
    }
    if (_formKey.currentState!.validate()) {
      final filePickerState = _formKey.currentState?.fields['file']
          as FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>;
      final fileValue = filePickerState.value;
      if (fileValue != null && fileValue.isNotEmpty) {
        final file = fileValue.first as PlatformFile;
        final bytes = await file.bytes;
        final csvString = utf8.decode(bytes!);
        final csvTable = csvString.split('\n');
        bool isCsvValid = true;
        String problems = '';
        for (String assignment in csvTable) {
          assignment = assignment.trim();
          if (assignment.isEmpty) continue;
          List<String> assignmentData = assignment.split(',');
          for (int i = 0; i < assignmentData.length; i++) {
            assignmentData[i] = assignmentData[i].trim();
          }
          if (assignmentData.length != 2) {
            isCsvValid = false;
            problems += 'Invalid number of columns in row: $assignment\n';
            break;
          }
          await FirebaseFirestore.instance
              .collection('assigned_panel')
              .where('panel_id', isEqualTo: assignmentData[0])
              .get()
              .then((value) async {
            if (value.docs.isEmpty) {
              isCsvValid = false;
              problems += 'Panel ${assignmentData[0]} not found\n';
              return;
            }
            await FirebaseFirestore.instance
                .collection('team')
                .where('id', isEqualTo: assignmentData[1])
                .get()
                .then((teamValue) async {
              if (teamValue.docs.isEmpty) {
                print('${assignmentData[1]} ${teamValue.docs.length}');
                isCsvValid = false;
                problems += 'Team ${assignmentData[1]} not found\n';
                return;
              }
            });
            var doc = value.docs[0];
            String panelType = doc['term'], course = doc['course'];
            String projectId = '';
            await FirebaseFirestore.instance
                .collection('projects')
                .where('team_id', isEqualTo: assignmentData[1])
                .where('semester', isEqualTo: currentSemester)
                .where('year', isEqualTo: currentYear)
                .where('type', isEqualTo: course)
                .get()
                .then((projectValue) async {
              if (projectValue.docs.isEmpty) {
                isCsvValid = false;
                problems +=
                    'Project for Team ${assignmentData[1]} of type $course, semester $currentSemester and $currentYear not found\n';
                return;
              } else {
                if (projectValue.docs.length > 1) {
                  print(
                      'assign_teams_to_panels_from_CSV_form.dart: More than one project found in same course, semester, year for team ${assignmentData[1]}');
                  isCsvValid = false;
                  problems +=
                      'More than one project found in same course, semester, year for team ${assignmentData[1]}\n';
                  return;
                } else {
                  var projectDoc = projectValue.docs[0];
                  projectId = projectDoc.id;
                  int numberOfPanelsAssigned = projectDoc['panel_ids'].length;
                  if (panelType == 'All' && numberOfPanelsAssigned != 0) {
                    isCsvValid = false;
                    problems +=
                        'Team ${assignmentData[1]}already assigned to a panel\n';
                    return;
                  } else if (panelType == 'MidTerm' &&
                      numberOfPanelsAssigned != 0) {
                    isCsvValid = false;
                    problems +=
                        'Team ${assignmentData[1]}already assigned to a panel\n';
                    return;
                  } else if (panelType == 'EndTerm' &&
                      numberOfPanelsAssigned == 2) {
                    isCsvValid = false;
                    problems +=
                        'Team ${assignmentData[1]}already assigned to a panel\n';
                    return;
                  }
                }
              }
            });
            if (projectId != '') {
              await FirebaseFirestore.instance
                  .collection('evaluations')
                  .where('project_id', isEqualTo: projectId)
                  .get()
                  .then((evaluationValue) {
                if (evaluationValue.docs.isEmpty) {
                  isCsvValid = false;
                  problems += 'Evaluation for project ${projectId} not found\n';
                  return;
                } else if (evaluationValue.docs.length > 1) {
                  isCsvValid = false;
                  problems +=
                      'More than one evaluation found for project of, team ${assignmentData[1]}\n';
                  return;
                }
              });
            }
          });

          if (!isCsvValid) {
            problems +=
                'Panel ${assignmentData[0]} and Team ${assignmentData[1]} combination invalid\n';
          }
          if (!isCsvValid) {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const FormCustomText(text: 'Invalid CSV'),
                    content: FormCustomText(text: problems),
                  );
                });
            // int cnt = 1000000000;
            // while (cnt-- > 0) {}
            return;
          }
        }

        for (String assignment in csvTable) {
          assignment = assignment.trim();
          if (assignment.isEmpty) continue;
          List<String> assignmentData = assignment.split(',');
          for (int i = 0; i < assignmentData.length; i++) {
            assignmentData[i] = assignmentData[i].trim();
          }
          String projectID = '';
          List<String> evaluators = [];
          String course = '';
          String panelType = '';
          List<String> studentEntryNumbers = [];
          bool aborted = false;
          await FirebaseFirestore.instance
              .collection('assigned_panel')
              .where('panel_id', isEqualTo: assignmentData[0])
              .get()
              .then((panelValue) async {
            if (panelValue.docs.isNotEmpty) {
              var panelDoc = panelValue.docs[0];
              evaluators = panelDoc['evaluator_ids'].cast<String>();
              course = panelDoc['course'];
              panelType = panelDoc['term'];
            } else {
              aborted = true;
            }
          });
          await FirebaseFirestore.instance
              .collection('team')
              .where('id', isEqualTo: assignmentData[1])
              .get()
              .then((teamValue) {
            if (teamValue.docs.isNotEmpty) {
              studentEntryNumbers = teamValue.docs[0]['students'];
            } else {
              aborted = false;
            }
          });
          await FirebaseFirestore.instance
              .collection('projects')
              .where('team_id', isEqualTo: assignmentData[1])
              .where('semester', isEqualTo: currentSemester)
              .where('year', isEqualTo: currentYear)
              .where('type', isEqualTo: course)
              .get()
              .then((value) async {
            if (value.docs.isNotEmpty) {
              var doc = value.docs[0];
              projectID = doc.id;
            } else {
              aborted = true;
            }
          });

          if (projectID == '' ||
              evaluators.isEmpty ||
              course == '' ||
              aborted) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const FormCustomText(text: 'Unexpected Error'),
                    content: FormCustomText(
                        text:
                            'Occurred at Panel ${assignmentData[0]} and Team ${assignmentData[1]} combination. Aborting the rest!'),
                  );
                });
            return;
          }
          await FirebaseFirestore.instance
              .collection('instructors')
              .where('uid', whereIn: evaluators)
              .get()
              .then((value) async {
            if (value.docs.isNotEmpty) {
              for (var instructor in value.docs) {
                int number_of_projects_as_panel =
                    instructor['number_of_projects_panel'];
                var project_as_panel_ids = instructor['project_as_panel_ids'];
                project_as_panel_ids.add(projectID);
                number_of_projects_as_panel += 1;
                await FirebaseFirestore.instance
                    .collection('instructors')
                    .doc(instructor.id)
                    .update({
                  'number_of_projects_panel': number_of_projects_as_panel,
                  'project_as_panel_ids': project_as_panel_ids
                });
              }
            }
          });

          await FirebaseFirestore.instance
              .collection('projects')
              .doc(projectID)
              .get()
              .then((projectValue) async {
            if (projectValue.exists) {
              List panel_ids = projectValue['panel_ids'];
              panel_ids.add(assignmentData[0]);
              await FirebaseFirestore.instance
                  .collection('projects')
                  .doc(projectID)
                  .update({'panel_ids': panel_ids});
            }
          });

          await FirebaseFirestore.instance
              .collection('evaluations')
              .where('project_id', isEqualTo: projectID)
              .get()
              .then((evaluationValue) async {
            if (evaluationValue.docs.isNotEmpty) {
              var evaluationDoc = evaluationValue.docs[0];
              List assigned_panels = evaluationDoc['assigned_panels'];
              assigned_panels.add(assignmentData[0]);
              var dataToUpdate = {'assigned_panels': assigned_panels};
              var genericMap = {};
              for (var student in studentEntryNumbers) {
                genericMap.addEntries([MapEntry(student, null)]);
              }
              List ArrayOfMap =
                  List.generate(evaluators.length, (index) => genericMap);

              if (panelType == 'MidTerm') {
                dataToUpdate
                    .addEntries([MapEntry('midsem_evaluation', ArrayOfMap)]);
                dataToUpdate.addEntries(
                    [MapEntry('midsem_panel_comments', ArrayOfMap)]);
              } else if (panelType == 'EndTerm') {
                dataToUpdate
                    .addEntries([MapEntry('endsem_evaluation', ArrayOfMap)]);
                dataToUpdate.addEntries(
                    [MapEntry('endsem_panel_comments', ArrayOfMap)]);
              } else if (panelType == 'All') {
                dataToUpdate
                    .addEntries([MapEntry('midsem_evaluation', ArrayOfMap)]);
                dataToUpdate.addEntries(
                    [MapEntry('midsem_panel_comments', ArrayOfMap)]);
                dataToUpdate
                    .addEntries([MapEntry('endsem_evaluation', ArrayOfMap)]);
                dataToUpdate.addEntries(
                    [MapEntry('endsem_panel_comments', ArrayOfMap)]);
              }
              await FirebaseFirestore.instance
                  .collection('evaluations')
                  .doc(evaluationDoc.id)
                  .update(dataToUpdate);
            }

            await FirebaseFirestore.instance
                .collection('assigned_panel')
                .where('panel_id', isEqualTo: assignmentData[0])
                .get()
                .then((assignedPanelValue) async {
              if (assignedPanelValue.docs.isNotEmpty) {
                var assignedPanelDoc = assignedPanelValue.docs[0];
                List assigned_project_ids =
                    assignedPanelDoc['assigned_project_ids'];
                assigned_project_ids.add(projectID);
                await FirebaseFirestore.instance
                    .collection('assigned_panel')
                    .doc(assignedPanelDoc.id)
                    .update({
                  'assigned_project_ids': assigned_project_ids,
                  'number_of_assigned_projects':
                      assigned_project_ids.length.toString(),
                });
              }
            });

            await FirebaseFirestore.instance
                .collection('panels')
                .where('panel_id', isEqualTo: assignmentData[0])
                .get()
                .then((panelValue) {
              if (panelValue.docs.isNotEmpty) {
                var panelDoc = panelValue.docs[0];
                List assigned_project_ids = panelDoc['assigned_project_ids'];
                assigned_project_ids.add(projectID);
                FirebaseFirestore.instance
                    .collection('panels')
                    .doc(panelDoc.id)
                    .update({
                  'assigned_project_ids': assigned_project_ids,
                  'number_of_assigned_projects':
                      assigned_project_ids.length.toString(),
                });
              }
            });
          });
        }
      }
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            width: 500,
            child: CustomisedText(
              text: 'Format: PanelID,TeamID...',
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
                enabled: currentSemester != '' && currentYear != '',
                onPressed: () {
                  _onFormSubmitted();
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
