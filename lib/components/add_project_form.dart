import 'package:casper/components/customised_text.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/components/form_custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:multiselect/multiselect.dart';

class AddProjectForm extends StatefulWidget {
  AddProjectForm({
    super.key,
  });

  @override
  State<AddProjectForm> createState() => _AddProjectFormState();
}

class _AddProjectFormState extends State<AddProjectForm> {
  int status = 0;
  final _formKey = GlobalKey<FormBuilderState>();
  String semester = '', year = '';

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
      return const FormCustomText(text: 'Project added successfully');
    }

    List<String> vals = [];
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
            text: 'Select the course',
            color: Colors.black,
          ),
          FormBuilderDropdown(
            name: 'type',
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
            text: 'Enter the project name',
            color: Colors.black,
          ),
          FormBuilderTextField(
            name: 'title',
            validator: FormBuilderValidators.required(
              errorText: 'Please enter a valid project name',
            ),
            cursorColor: Colors.black,
            decoration: getDecoration('Title'),
          ),
          const SizedBox(
            height: 10,
          ),
          const CustomisedText(
            text: 'Enter the project description',
            color: Colors.black,
          ),
          FormBuilderTextField(
            name: 'description',
            validator: FormBuilderValidators.required(
                errorText: 'Please enter a valid project description'),
            cursorColor: Colors.black,
            decoration: getDecoration('Description'),
          ),
          const SizedBox(
            height: 10,
          ),
          const CustomisedText(
            text: 'Select the departments to open the project for',
            color: Colors.black,
          ),
          DropDownMultiSelect(
            options: const ['CSE', 'EE', 'MCB', 'CE', 'ME'],
            selectedValues: vals,
            onChanged: (values) => vals = values,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
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

                    if (vals.isEmpty) {
                      return;
                    } else {
                      final data = _formKey.currentState?.value.entries;
                      var alldata = <String, dynamic>{};
                      alldata.addEntries(data!);
                      alldata.addEntries([
                        MapEntry('open_for', vals),
                        MapEntry('instructor_id',
                            FirebaseAuth.instance.currentUser!.uid),
                      ]);
                      FirebaseFirestore.instance
                          .collection('instructors')
                          .where('uid',
                              isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                          .get()
                          .then((value) {
                        var doc = value.docs[0];
                        var entries = [
                          ['department', doc['department']],
                          ['instructor_name', doc['name']],
                          ['status', 'open'],
                        ];
                        alldata.addEntries(
                            entries.map((e) => MapEntry(e[0], e[1])));
                        FirebaseFirestore.instance
                            .collection('offerings')
                            .add(alldata);
                        setState(() {
                          status = 2;
                        });
                      });
                    }
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
