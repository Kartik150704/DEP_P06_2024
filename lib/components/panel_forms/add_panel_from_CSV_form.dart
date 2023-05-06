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

class CreatePanelFromCSVForm extends StatefulWidget {
  const CreatePanelFromCSVForm({
    super.key,
  });

  @override
  State<CreatePanelFromCSVForm> createState() => _CreatePanelFromCSVFormState();
}

class _CreatePanelFromCSVFormState extends State<CreatePanelFromCSVForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _onFormSubmitted() {
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
        int newpanelid = 0;
        FirebaseFirestore.instance.collection('panels').get().then((value) {
          for (var doc in value.docs) {
            if (int.parse(doc['panel_id']) > newpanelid) {
              newpanelid = int.parse(doc['panel_id']);
            }
          }
          newpanelid++;
          bool flag = true;
          for (int i = 0; i < csvData.length; i++) {
            if (!flag) {
              break;
            }
            List<String> emails = csvData[i].split(',');
            for (int j = 0; j < emails.length; j++) {
              emails[j] = emails[j].trim();
            }
            FirebaseFirestore.instance
                .collection('instructors')
                .where('email', whereIn: emails)
                .get()
                .then((value) {
              if (value.docs.length != emails.length) {
                print(emails);
                print('Multiple instructors with same email, unexpected error');
                flag = false;
                return;
              } else {
                List<String> names = [], ids = [];
                for (String email in emails) {
                  for (var doc in value.docs) {
                    if (doc['email'] == email) {
                      names.add(doc['name']);
                      ids.add(doc['uid']);
                      break;
                    }
                  }
                }

                if (names.length != ids.length ||
                    names.length != emails.length) {
                  flag = false;
                  return;
                }

                var alldata = <String, dynamic>{};
                alldata.addEntries([
                  MapEntry('evaluator_names', names),
                  //TODO: validation of ids and names
                  MapEntry('evaluator_ids', ids)
                ]);

                // TODO: change                newpanelid = value.docs.length + 1;;
                print(newpanelid + i);
                alldata.addEntries([
                  MapEntry('number_of_evaluators', emails.length.toString()),
                  MapEntry('panel_id', (newpanelid + i).toString()),
                  const MapEntry('number_of_assigned_projects', '0'),
                  const MapEntry('assigned_project_ids', [])
                ]);
                FirebaseFirestore.instance.collection('panels').add(alldata);
                alldata.addEntries([
                  MapEntry('semester', formdata!['semester']),
                  MapEntry('year', formdata['year']),
                  MapEntry('term', formdata['term']),
                  MapEntry('course', formdata['course']),
                ]);
                FirebaseFirestore.instance
                    .collection('assigned_panel')
                    .add(alldata);
              }
            });
          }

          if (!flag) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Please verify inputted data'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'))
                    ],
                  );
                });
          }
        });
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
          Text(
            'Enter the semester',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          FormBuilderTextField(
            name: 'semester',
            validator: (value) => integerValidator(value, 'semester', 1, 2),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Enter the year',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          FormBuilderTextField(
            name: 'year',
            validator: (value) => integerValidator(value, 'year', 2000, 2100),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Enter the term',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          FormBuilderTextField(
            name: 'term',
            validator: (value) {
              if (['MidTerm', 'EndTerm'].contains(value)) {
                return null;
              }
              return 'enter a valid term. [MidTerm or EndTerm]';
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Enter the course',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          FormBuilderTextField(
            name: 'course',
            validator: (value) {
              if (['CP301', 'CP302', 'CP303'].contains(value)) {
                return null;
              }
              return 'enter a valid course. [CP301, CP302, CP303]';
            },
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            width: 500,
            child: CustomisedText(
              text:
                  'Format: \n panel1 email1, panel1 email2 ...\n panel2 email1, panel2 email2 ...\n ',
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
              validator: FormBuilderValidators.required(errorText: 'Reuuired'),
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
