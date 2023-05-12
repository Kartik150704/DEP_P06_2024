import 'package:casper/comp/customised_text.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/components/form_custom_text.dart';
import 'package:casper/utilities/utilites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

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
  int status = 0;
  final _formKey = GlobalKey<FormBuilderState>();
  // ignore: non_constant_identifier_names
  int number_of_evaluators = 1;
  String semester = '', year = '';

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
        print('no active session found');
      }
    });
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    number_of_evaluators = 1;
    getSession();
  }

  String? integerValidator(
      String? value, String fieldName, int lowerLimit, int higherLimit) {
    if (value == null) {
      return 'Please enter a valid $fieldName';
    }
    int? val = int.tryParse(value);
    if (val == null) {
      return 'Please enter a valid $fieldName';
    } else if (val > higherLimit || val < lowerLimit) {
      return 'Please enter a valid $fieldName';
    }
    return null;
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
      return const FormCustomText(
        text: 'Panel added successfully',
      );
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
          const CustomisedText(
            text: 'Select the number of evaluators',
            color: Colors.black,
          ),
          FormBuilderDropdown(
            name: 'number_of_evaluators',
            validator: (value) {
              if (value == null) {
                return 'Please pick an option';
              }
              return null;
            },
            items: List<String>.generate(3, (index) => '${index + 1}')
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                if (integerValidator(value, 'number between 1 and 3', 1, 4) ==
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
                  CustomisedText(
                    text: 'Enter evaluator ${i + 1} email',
                    color: Colors.black,
                  ),
                  FormBuilderTextField(
                    name: 'evaluator${i}id',
                    validator: FormBuilderValidators.required(
                        errorText: 'Please enter a valid email'),
                    cursorColor: Colors.black,
                    decoration: getDecoration('Email ${i + 1}'),
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
              CustomisedButton(
                width: 70,
                height: 50,
                text: 'Submit',
                onPressed: () {
                  _formKey.currentState?.save();
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      status = 1;
                    });

                    var emails = List<String>.generate(
                        number_of_evaluators,
                        (index) => _formKey
                            .currentState?.value['evaluator${index}id']);
                    var formdata = _formKey.currentState?.value;
                    FirebaseFirestore.instance
                        .collection('instructors')
                        .where('email', whereIn: emails)
                        .get()
                        .then((value) async {
                      if (value.docs.length != number_of_evaluators) {
                        print(
                            'Multiple instructors with same email, unexpected error');
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Please verify input data'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'))
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
                                  title: const Text('Please verify input data'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'))
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
                        String dept = '';
                        await FirebaseFirestore.instance
                            .collection('instructors')
                            .where('uid',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser?.uid)
                            .get()
                            .then((instructorValue) async {
                          if (instructorValue.docs.isNotEmpty) {
                            var doc = instructorValue.docs[0];
                            dept = doc['department'];
                          } else {
                            print(
                                'add_panel_form.dart -> instructor not found in instructors table');
                          }
                        });
                        if (dept == '') {
                          print(
                              'add_panel_form.dart -> unexpected error, invalid department');
                          return;
                        }
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
                            MapEntry('department', dept),
                          ]);
                          FirebaseFirestore.instance
                              .collection('assigned_panel')
                              .add(alldata);
                          widget.refresh();
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
                            temp.add((newpanelid).toString());
                            FirebaseFirestore.instance
                                .collection('instructors')
                                .doc(doc.id)
                                .update({'panel_ids': temp});
                            widget.refresh;
                          }
                        });
                      }
                    });
                    setState(() {
                      status = 2;
                    });
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
