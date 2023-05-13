// ignore: file_names
import 'dart:convert';
import 'package:casper/components/customised_overflow_text.dart';
import 'package:casper/components_new/customised_button.dart';
import 'package:casper/components_new/form_custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

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
  int status = 0;
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
      setState(() {
        status = 1;
      });

      final filePickerState = _formKey.currentState?.fields['file']
          as FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>;
      final fileValue = filePickerState.value;
      if (fileValue != null && fileValue.isNotEmpty) {
        final file = fileValue.first as PlatformFile;
        final bytes = file.bytes;
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
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const FormCustomText(text: 'Invalid CSV'),
                    content: FormCustomText(text: problems),
                  );
                });
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
              studentEntryNumbers =
                  teamValue.docs[0]['students'].cast<String>();
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
                int numberOfProjectsAsPanel =
                    instructor['number_of_projects_panel'];
                var projectAsPanelIds = instructor['project_as_panel_ids'];
                projectAsPanelIds.add(projectID);
                numberOfProjectsAsPanel += 1;
                await FirebaseFirestore.instance
                    .collection('instructors')
                    .doc(instructor.id)
                    .update({
                  'number_of_projects_panel': numberOfProjectsAsPanel,
                  'project_as_panel_ids': projectAsPanelIds
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
              List panelIds = projectValue['panel_ids'];
              panelIds.add(assignmentData[0]);
              await FirebaseFirestore.instance
                  .collection('projects')
                  .doc(projectID)
                  .update({'panel_ids': panelIds});
            }
          });

          await FirebaseFirestore.instance
              .collection('evaluations')
              .where('project_id', isEqualTo: projectID)
              .get()
              .then((evaluationValue) async {
            if (evaluationValue.docs.isNotEmpty) {
              var evaluationDoc = evaluationValue.docs[0];
              List assignedPanels = evaluationDoc['assigned_panels'];
              assignedPanels.add(assignmentData[0]);
              var dataToUpdate = {'assigned_panels': assignedPanels};
              var genericMap = {};
              for (var student in studentEntryNumbers) {
                genericMap.addEntries([MapEntry(student, null)]);
              }
              // ignore: non_constant_identifier_names
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
                List assignedProjectIds =
                    assignedPanelDoc['assigned_project_ids'];
                assignedProjectIds.add(projectID);
                await FirebaseFirestore.instance
                    .collection('assigned_panel')
                    .doc(assignedPanelDoc.id)
                    .update({
                  'assigned_project_ids': assignedProjectIds,
                  'number_of_assigned_projects':
                      assignedProjectIds.length.toString(),
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
                List assignedProjectIds = panelDoc['assigned_project_ids'];
                assignedProjectIds.add(projectID);
                FirebaseFirestore.instance
                    .collection('panels')
                    .doc(panelDoc.id)
                    .update({
                  'assigned_project_ids': assignedProjectIds,
                  'number_of_assigned_projects':
                      assignedProjectIds.length.toString(),
                });
              }
            });
          });
        }
      }
      setState(() {
        status = 2;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    if (status == 1) {
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
      return const FormCustomText(text: 'Teams assigned successfully');
    }

    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            width: 400,
            child: CustomisedOverflowText(
              text:
                  '       Required format:\n            panel id, team id\n            panel id, team id\n            ..',
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          SizedBox(
            width: 200,
            height: 125,
            child: FormBuilderFilePicker(
              name: 'file',
              maxFiles: 1,
              validator: FormBuilderValidators.required(
                errorText: 'Please upload a CSV file',
              ),
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
              CustomisedButton(
                width: 70,
                height: 50,
                text: 'Submit',
                onPressed: () => {
                  _onFormSubmitted(),
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
    );
  }
}
