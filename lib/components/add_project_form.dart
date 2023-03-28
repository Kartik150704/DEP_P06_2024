import 'package:casper/utilites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/text_field.dart';
import 'package:casper/components/button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
          ),
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
                    alldata
                        .addEntries(entries.map((e) => MapEntry(e[0], e[1])));
                    print(alldata);
                    FirebaseFirestore.instance
                        .collection('offerings')
                        .add(alldata);
                  });
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
