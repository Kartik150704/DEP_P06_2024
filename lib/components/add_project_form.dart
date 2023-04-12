import 'package:casper/utilites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/text_field.dart';
import 'package:casper/components/button.dart';
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
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    List<String> vals = [];
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            'Enter the project name',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          FormBuilderTextField(
              name: 'title',
              validator: FormBuilderValidators.required(
                  errorText: 'Title cannot be blank')),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Enter the description',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          FormBuilderTextField(
            name: 'description',
            validator: FormBuilderValidators.required(
                errorText: 'Description cannot be blank'),
          ),
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
            validator: (value) {
              if (value == null) {
                return 'Semester cannot be blank';
              } else if (int.tryParse(value) == null) {
                return 'Semester must be numeric';
              } else if (int.tryParse(value)! > 2 || int.tryParse(value)! < 1) {
                return 'Enter valid semester';
              } else {
                return null;
              }
            },
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
            validator: (value) {
              if (value == null) {
                return 'Year cannot be blank';
              } else if (int.tryParse(value) == null) {
                return 'Year must be numeric';
              } else if (int.tryParse(value)! < 2000) {
                return 'Enter valid year';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Enter the project type',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          FormBuilderDropdown(
            name: 'type',
            items: ['CP302', 'CP303']
                .map((e) => DropdownMenuItem(
                      child: Text('$e'),
                      value: e,
                    ))
                .toList(),
            validator: FormBuilderValidators.required(
                errorText: 'Type cannot be blank'),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Enter the departments to open for',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          DropDownMultiSelect(
            options: ['CS', 'EE', 'MA'],
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
              CustomButton(
                buttonText: 'Submit',
                onPressed: () {
                  _formKey.currentState?.save();
                  if (_formKey.currentState!.validate()) {
                    if (vals.isEmpty) {
                      return;
                    } else {
                      final data = _formKey.currentState?.value.entries;
                      var alldata = <String, dynamic>{};
                      alldata.addEntries(data!);
                      alldata.addEntries([MapEntry('open_for', vals)]);
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
                        print(alldata);
                        FirebaseFirestore.instance
                            .collection('offerings')
                            .add(alldata);
                        Navigator.pop(context);
                      });
                    }
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
