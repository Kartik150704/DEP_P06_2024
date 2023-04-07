import 'dart:math';
import 'dart:convert';
import 'package:casper/components/customised_text.dart';
import 'package:casper/utilites.dart';
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

class StudentTeamAssignmentForm extends StatefulWidget {
  const StudentTeamAssignmentForm({
    super.key,
  });

  @override
  State<StudentTeamAssignmentForm> createState() =>
      _StudentTeamAssignmentFormState();
}

class _StudentTeamAssignmentFormState extends State<StudentTeamAssignmentForm> {
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
        final csvTable = csvString.split(',');
        setState(() {
          csvData = csvTable;
        });
        // Do something with the CSV data
        // ...
        for (int i = 0; i < csvData.length; i += 2) {
          var alldata = <String, dynamic>{};
          List<String> name = [], entry = [];
          alldata.addEntries([MapEntry('panel_id', csvData[i])]);
          int newpanelid = 0;
          FirebaseFirestore.instance
              .collection('team')
              .get()
              .then((value) async {
            //TODO change to len + 1
            for (var doc in value.docs) {
              if (doc['id'].toString() == csvData[i + 1].toString()) {
                for (String x in doc['students']) {
                  // print(doc['id']);
                  // print(x);
                  entry.add(x);
                  await FirebaseFirestore.instance
                      .collection('student')
                      .get()
                      .then((values) {
                    for (var docc in values.docs) {
                      if (docc['id'] == x) {
                        name.add(docc['name']);
                      }
                    }
                  });
                }
              }
            }
            print(name);
            alldata.addEntries([
              MapEntry('entry_no', entry),
              MapEntry('name', name),
              MapEntry('team_id', csvData[i + 1]),
            ]);
            FirebaseFirestore.instance
                .collection('assigned_panel')
                .add(alldata);
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
          // Text(
          //   'Upload file',
          //   style: SafeGoogleFont(
          //     'Ubuntu',
          //     fontSize: 20,
          //     fontWeight: FontWeight.w500,
          //     color: const Color(0xff000000),
          //   ),
          // ),
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
