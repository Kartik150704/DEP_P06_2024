import 'dart:convert';

import 'package:casper/comp/customised_text.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/components/form_custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

import '../components/button.dart';

class AddInstructorForm extends StatefulWidget {
  const AddInstructorForm({
    super.key,
  });

  @override
  State<AddInstructorForm> createState() => _AddInstructorFormState();
}

class _AddInstructorFormState extends State<AddInstructorForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  String selectedEvent = '';
  List<String> csvData = [];

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

        for (int i = 0; i < csvData.length; i++) {
          List<String> instructor = csvData[i].split(',');
          for (int j = 0; j < instructor.length; j++) {
            instructor[j] = instructor[j].trim();
          }
          print(instructor);
          UserCredential result = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: instructor[2], password: instructor[3]);
          User? user = result.user;
          await FirebaseFirestore.instance.collection('users').add({
            'uid': user!.uid,
            'name': '${instructor[0]} ${instructor[1]}',
            'role': 'supervisor',
          });

          await FirebaseFirestore.instance.collection('instructors').add({
            'name': '${instructor[0]} ${instructor[1]}',
            'email': instructor[2],
            'uid': user.uid,
            'department': 'CS',
            'contact': '1234567890',
            'number_of_projects_panel': 0,
            'number_of_projects_as_head': 0,
            'panel_ids': List.generate(0, (index) => null),
            'project_as_head_ids': List.generate(0, (index) => null),
            'project_as_panel_ids': List.generate(0, (index) => null),
          });
        }
      }
    }
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
              text: 'Format: FirstName, LastName, Email, Password.\n...',
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
