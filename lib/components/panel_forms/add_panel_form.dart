import 'dart:math';

import 'package:casper/utilities/utilites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/text_field.dart';
import 'package:casper/components/button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:multiselect/multiselect.dart';

class AddPanelForm extends StatefulWidget {
  final refresh;

  const AddPanelForm({
    super.key,
    required this.refresh,
  });

  @override
  State<AddPanelForm> createState() => _AddPanelFormState();
}

class _AddPanelFormState extends State<AddPanelForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  int number_of_evaluators = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    number_of_evaluators = 1;
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
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
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
          Text(
            'Enter the number of evaluators',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          FormBuilderTextField(
            name: 'number_of_evaluators',
            validator: (value) => integerValidator(
                value, 'number of evaluators from 1 to 5', 1, 5),
            initialValue: '1',
            onChanged: (value) {
              setState(() {
                if (integerValidator(
                        value, 'number of evaluators from 1 to 5', 1, 5) ==
                    null) {
                  number_of_evaluators = int.parse(value!);
                }
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                for (int i = 0; i < number_of_evaluators; i++) ...[
                  Text(
                    'Evaluator ${i + 1} email: ',
                    style: SafeGoogleFont(
                      'Ubuntu',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff000000),
                    ),
                  ),
                  FormBuilderTextField(
                    name: 'evaluator${i}id',
                    validator: FormBuilderValidators.required(
                        errorText: 'email cannot be empty'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ]
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
                onPressed: () {
                  _formKey.currentState?.save();
                  if (_formKey.currentState!.validate()) {
                    var emails = List<String>.generate(
                        number_of_evaluators,
                        (index) => _formKey
                            .currentState?.value['evaluator${index}id']);
                    var formdata = _formKey.currentState?.value;
                    FirebaseFirestore.instance
                        .collection('instructors')
                        .where('email', whereIn: emails)
                        .get()
                        .then((value) {
                      if (value.docs.length != number_of_evaluators) {
                        print(
                            'Multiple instructors with same email, unexpected error');
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
                            names.length != number_of_evaluators) {
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
                          return;
                        }

                        var alldata = <String, dynamic>{};
                        alldata.addEntries([
                          MapEntry('evaluator_names', names),
                          //TODO: validation of ids and names
                          MapEntry('evaluator_ids', ids)
                        ]);
                        int newpanelid = 0;
                        FirebaseFirestore.instance
                            .collection('panels')
                            .get()
                            .then((value) {
                          for (var doc in value.docs) {
                            if (int.parse(doc['panel_id']) > newpanelid) {
                              newpanelid = int.parse(doc['panel_id']);
                            }
                          }
                          newpanelid++;
                          alldata.addEntries([
                            MapEntry('number_of_evaluators',
                                number_of_evaluators.toString()),
                            MapEntry('panel_id', newpanelid.toString()),
                            const MapEntry('number_of_assigned_projects', '0'),
                            const MapEntry('assigned_project_ids', [])
                          ]);
                          FirebaseFirestore.instance
                              .collection('panels')
                              .add(alldata);
                          alldata.addEntries([
                            MapEntry('semester', formdata!['semester']),
                            MapEntry('year', formdata['year']),
                            MapEntry('term', formdata['term']),
                            MapEntry('course', formdata['course']),
                          ]);
                          FirebaseFirestore.instance
                              .collection('assigned_panel')
                              .add(alldata);
                          widget.refresh();
                        });
                      }
                    });

                    Navigator.pop(context);
                  }
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
