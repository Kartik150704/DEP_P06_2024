import 'dart:convert';
import 'package:casper/comp/customised_overflow_text.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/components/form_custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

class AddFacultyForm extends StatefulWidget {
  const AddFacultyForm({
    super.key,
  });

  @override
  State<AddFacultyForm> createState() => _AddFacultyFormState();
}

class _AddFacultyFormState extends State<AddFacultyForm> {
  int status = 0;
  bool loading = false;
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
    setState(() {
      status = 1;
    });

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

        for (int i = 0; i < csvData.length; i++) {
          List<String> instructor = csvData[i].split(',');
          for (int j = 0; j < instructor.length; j++) {
            instructor[j] = instructor[j].trim();
          }

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
          setState(() {
            status = 2;
          });
        }
      }
    }

    setState(() {
      status = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (status == 1) {
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
      return const FormCustomText(text: 'Faculty added successfully');
    }

    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            width: 470,
            child: CustomisedOverflowText(
              text:
                  '       Required format:\n          first name, last name, email, password\n          first name, last name, email, password\n          ..',
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 200,
            height: 125,
            child: FormBuilderFilePicker(
              name: 'file',
              maxFiles: 1,
              allowedExtensions: const ['csv'],
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please upload a CSV file';
                }
                return null;
              },
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
                width: 100,
                height: 55,
                text: 'Submit',
                onPressed: () async => {
                  await _onFormSubmitted(),
                },
              ),
              CustomisedButton(
                width: 100,
                height: 55,
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
