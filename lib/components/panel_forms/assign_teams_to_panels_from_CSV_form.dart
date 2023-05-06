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

  Future<void> _onFormSubmitted() async {
    _formKey.currentState?.save();
    if (_formKey.currentState!.validate()) {
      final filePickerState = _formKey.currentState?.fields['file']
          as FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>;
      final fileValue = filePickerState.value;
      if (fileValue != null && fileValue.isNotEmpty) {
        final file = fileValue.first as PlatformFile;
        final bytes = await file.bytes;
        final csvString = utf8.decode(bytes!);
        final csvTable = csvString.split('\n');
        setState(() {
          csvData = csvTable;
          var x;
          var temp;
          for (int i = 0; i < csvData.length; i++) {
            temp = csvData[i].split(',');
            for (int j = 0; j < temp.length; j++) {
              x.add(temp[j]);
            }
          }
          csvData = x;
        });
        // Do something with the CSV data
        // ...
        for (int i = 0; i < csvData.length; i += 2) {
          var alldata = <String, dynamic>{};
          var eval_ids = [], entry = [];
          var proj_id = '';
          var panel_sz = 0;
          var panel_id = '';

          await FirebaseFirestore.instance
              .collection('projects')
              .get()
              .then((value) async {
            for (var doc in value.docs) {
              if (doc['team_id'] == csvData[i + 1]) {
                proj_id = doc.id;
                await FirebaseFirestore.instance
                    .collection('team')
                    .get()
                    .then((value) async {
                  for (var doc in value.docs) {
                    if (doc['id'] == csvData[i + 1]) {
                      entry = doc['students'];
                    }
                  }
                });
                break;
              }
            }
          });
          await FirebaseFirestore.instance
              .collection('assigned_panel')
              .get()
              .then((value) async {
            for (var doc in value.docs) {
              if (doc['panel_id'] == csvData[i]) {
                //get number_of_assigned_projects String and increase by 1 and add prj_id to assigned_project_ids
                var num = int.parse(doc['number_of_assigned_projects']) + 1;
                String num_str = num.toString();
                FirebaseFirestore.instance
                    .collection('assigned_panel')
                    .doc(doc.id)
                    .update({
                  'number_of_assigned_projects': num_str,
                  'assigned_project_ids': FieldValue.arrayUnion([proj_id]),
                });
              }
            }
          });
          await FirebaseFirestore.instance
              .collection('panels')
              .get()
              .then((value) {
            for (var doc in value.docs) {
              if (doc['panel_id'] == csvData[i]) {
                panel_id = doc.id;
                eval_ids = doc['evaluator_ids'];
                panel_sz = int.parse(doc['number_of_evaluators']);
                //get number_of_assigned_projects String and increase by 1 and add prj_id to assigned_project_ids
                var num = int.parse(doc['number_of_assigned_projects']) + 1;
                String num_str = num.toString();
                FirebaseFirestore.instance
                    .collection('panels')
                    .doc(doc.id)
                    .update({
                  'number_of_assigned_projects': num_str,
                  'assigned_project_ids': FieldValue.arrayUnion([proj_id]),
                });
              }
            }
          });
          print(panel_sz);
          print('eval_ids: $entry');
          for (var inst in eval_ids) {
            await FirebaseFirestore.instance
                .collection('instructors')
                .get()
                .then((value) async {
              for (var doc in value.docs) {
                if (doc['uid'] == inst) {
                  FirebaseFirestore.instance
                      .collection('instructors')
                      .doc(doc.id)
                      .update({
                    'number_of_projects_panel': FieldValue.increment(1),
                    'project_as_panel_ids': FieldValue.arrayUnion([proj_id]),
                  });
                }
              }
            });
          }

          await FirebaseFirestore.instance
              .collection('evaluations')
              .where('project_id', isEqualTo: proj_id)
              .get()
              .then((value) async {
            for (var doc in value.docs) {
              if (doc['project_id'] == proj_id) {
                List<Map<String, dynamic>> arr = [];
                Map<String, dynamic> marks = {};
                for (var entry_no in entry) {
                  marks[entry_no] = 'NA';
                }
                for (int i = 0; i < panel_sz; i++) {
                  arr.add(marks);
                }
                await FirebaseFirestore.instance
                    .collection('evaluations')
                    .doc(doc.id)
                    .update({
                  'endsem_evaluation': arr,
                  'midsem_evaluation': arr,
                  'endsem_panel_comments': arr,
                  'midsem_panel_comments': arr,
                  // TODO: not used may need to remove
                  'assigned_panels': FieldValue.arrayUnion([panel_id]),
                });
              }
            }
          });
        }
      }
    }
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
