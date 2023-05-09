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

import '../customised_button.dart';

class CreateTeamsForm extends StatefulWidget {
  const CreateTeamsForm({
    super.key,
  });

  @override
  State<CreateTeamsForm> createState() => _CreateTeamsFormState();
}

class _CreateTeamsFormState extends State<CreateTeamsForm> {
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
        });
        // Do something with the CSV data
        // ...

        List<String> allstudents = [];
        await FirebaseFirestore.instance
            .collection('team')
            .get()
            .then((teamSnapshot) async {
          for (QueryDocumentSnapshot doc in teamSnapshot.docs) {
            for (var student in doc['students']) {
              allstudents.add(student.toString());
            }
          }
        });
        bool flag = true;
        for (int i = 0; i < csvData.length; i++) {
          List<String> team = csvData[i].split(',');
          for (int j = 0; j < team.length; j++) {
            team[j] = team[j].trim();
          }
          for (String student in team) {
            if (allstudents.contains(student.trim())) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: CustomisedText(
                        text: 'Student $student is already in a team',
                        color: Colors.black,
                      ),
                      actions: [
                        CustomisedButton(
                          text: 'OK',
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          width: 50,
                          height: 100,
                        ),
                      ],
                    );
                  });
              flag = false;
            }
          }
        }

        if (!flag) {
          return;
        }
        int newTeamID = 0;
        await FirebaseFirestore.instance
            .collection('team')
            .get()
            .then((teamsSnapshot) async {
          newTeamID = teamsSnapshot.docs.length + 1;
        });

        for (int i = 0; i < csvData.length; i++) {
          if (csvData[i].length == 0) {
            continue;
          }
          List<String> team = csvData[i].split(',');
          for (int j = 0; j < team.length; j++) {
            team[j] = team[j].trim();
          }
          var alldata = <String, dynamic>{};
          alldata.addEntries([
            MapEntry('id', newTeamID.toString()),
            MapEntry('numberOfStudents', team.length.toString()),
            MapEntry('students', team),
          ]);
          await FirebaseFirestore.instance.collection('team').add(alldata);
          newTeamID++;
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
              text:
                  'Format: Team1Student1, Team1Student2\n Team2Student1, Team2Student2\n ...',
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
                onPressed: () async => {
                  await _onFormSubmitted(),
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
