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

class AddStudentForm extends StatefulWidget {
  const AddStudentForm({
    super.key,
  });

  @override
  State<AddStudentForm> createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<AddStudentForm> {
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
          List<String> student = csvData[i].split(',');
          for (int j = 0; j < student.length; j++) {
            student[j] = student[j].trim();
          }
          print(student);
          UserCredential result = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: student[2], password: student[3]);
          User? user = result.user;
          await FirebaseFirestore.instance.collection('users').add({
            'uid': user!.uid,
            'name': '${student[0]} ${student[1]}',
            'role': 'student',
          });

          await FirebaseFirestore.instance.collection('student').add({
            'name': '${student[0]} ${student[1]}',
            'id': student[3],
            'uid': user.uid,
            'cgpa': '8.66',
            'department': 'CS',
            'contact': '1234567890',
            'proj_id': List.generate(5, (index) => null),
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
              text: 'Format: FirstName, LastName, Email, EntryNo.\n...',
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
