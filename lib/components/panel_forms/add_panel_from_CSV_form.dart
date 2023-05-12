// ignore: file_names
import 'dart:convert';
import 'package:casper/comp/customised_overflow_text.dart';
import 'package:casper/comp/customised_text.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/components/form_custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CreatePanelFromCSVForm extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final refresh;

  const CreatePanelFromCSVForm({
    super.key,
    required this.refresh,
  });

  @override
  State<CreatePanelFromCSVForm> createState() => _CreatePanelFromCSVFormState();
}

class _CreatePanelFromCSVFormState extends State<CreatePanelFromCSVForm> {
  int status = 0;
  final _formKey = GlobalKey<FormBuilderState>();
  String selectedEvent = '', semester = '', year = '';

  void _onFormSubmitted() {
    _formKey.currentState?.save();
    if (_formKey.currentState!.validate()) {
      setState(() {
        status = 1;
      });

      final filePickerState = _formKey.currentState?.fields['file']
          as FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>;
      final formdata = _formKey.currentState?.value;
      final fileValue = filePickerState.value;
      if (fileValue != null && fileValue.isNotEmpty) {
        final file = fileValue.first as PlatformFile;
        final bytes = file.bytes;
        final csvString = utf8.decode(bytes!);
        final csvData = csvString.split('\n');
        for (var item in csvData) print(item);

        int newpanelid = 0;
        FirebaseFirestore.instance
            .collection('panels')
            .get()
            .then((value) async {
          for (var doc in value.docs) {
            if (int.parse(doc['panel_id']) > newpanelid) {
              newpanelid = int.parse(doc['panel_id']);
            }
          }
          newpanelid++;
          String dept = '';
          await FirebaseFirestore.instance
              .collection('instructors')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .get()
              .then((instructorValue) {
            if (instructorValue.docs.isNotEmpty) {
              var doc = instructorValue.docs[0];
              dept = doc['department'];
            } else {
              print(
                  'add_panel_from_CSV.dart -> instructor not found in instructors table');
            }
          });
          if (dept == '') {
            print(
                'add_panel_from_CSV.dart -> unexpected error, invalid department');
            return;
          }
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
                  //TODO: validation of ids and names
                  MapEntry('evaluator_names', names),
                  MapEntry('evaluator_ids', ids)
                ]);

                // TODO: change newpanelid = value.docs.length + 1;;
                alldata.addEntries([
                  MapEntry('number_of_evaluators', emails.length.toString()),
                  MapEntry('panel_id', (newpanelid + i).toString()),
                  const MapEntry('number_of_assigned_projects', '0'),
                  const MapEntry('assigned_project_ids', []),
                  MapEntry('department', dept),
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

            FirebaseFirestore.instance
                .collection('instructors')
                .where('email', whereIn: emails)
                .get()
                .then((value) {
              for (var doc in value.docs) {
                List<String> temp = [];
                if (doc['panel_ids'] != null) {
                  temp = List<String>.from(doc['panel_ids']);
                }
                temp.add((newpanelid + i).toString());
                FirebaseFirestore.instance
                    .collection('instructors')
                    .doc(doc.id)
                    .update({'panel_ids': temp});
                widget.refresh;
              }
            });
          }

          if (!flag) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'Please verify inputted data',
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'OK',
                        ))
                  ],
                );
              },
            );
          }
        });
      }

      setState(() {
        status = 2;
      });
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
      return const FormCustomText(text: 'Panels added successfully');
    }

    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
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
            text: 'Select the term',
            color: Color(0xff000000),
          ),
          FormBuilderRadioGroup(
            name: 'term',
            activeColor: Colors.black,
            validator: (value) {
              if (value == null) {
                return 'Please select a term';
              }
              return null;
            },
            options: const [
              // TODO: These are not static
              FormBuilderFieldOption(
                  value: 'MidTerm', child: FormCustomText(text: 'MidTerm')),
              FormBuilderFieldOption(
                  value: 'EndTerm', child: FormCustomText(text: 'EndTerm')),
              FormBuilderFieldOption(
                  value: 'Report', child: FormCustomText(text: 'Report')),
              FormBuilderFieldOption(
                  value: 'All', child: FormCustomText(text: 'All')),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const CustomisedText(
            text: 'Select the course',
            color: Colors.black,
          ),
          FormBuilderDropdown(
            name: 'course',
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
          const SizedBox(
            width: 400,
            child: CustomisedOverflowText(
              text:
                  '       Required format:\n          panel A email 1, panel A email 2, ...\n          panel B email 1, panel B email 2, ...\n          ..',
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
