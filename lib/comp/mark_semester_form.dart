import 'package:casper/comp/customised_text.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/components/form_custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class MarkSemesterForm extends StatefulWidget {
  const MarkSemesterForm({
    super.key,
  });

  @override
  State<MarkSemesterForm> createState() => _AddEventFormState();
}

class _AddEventFormState extends State<MarkSemesterForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  String selectedEvent = '';
  String semester = '', year = '', status = '';
  late bool loading, validSession;

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
        setState(() {
          semester = value.docs[0]['semester'];
          year = value.docs[0]['year'];
          validSession = true;
        });
      } else {
        validSession = false;
      }

      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    validSession = true;
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const CircularProgressIndicator(
        color: Colors.black,
      );
    } else if (status == 'completed') {
      return const FormCustomText(
        text: 'Event added successfully',
      );
    } else if (status == 'failed') {
      return const FormCustomText(
        text: 'Event could not be added',
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
            color: Colors.black,
          ),
          FormBuilderTextField(
            name: 'semester',
            validator: (value) => integerValidator(value, 'semester', 1, 2),
            initialValue: semester,
            enabled: true,
            decoration: getDecoration('Semester'),
          ),
          const SizedBox(
            height: 10,
          ),
          const CustomisedText(text: 'Year', color: Colors.black),
          FormBuilderTextField(
            name: 'year',
            validator: (value) => integerValidator(value, 'year', 2000, 2100),
            initialValue: year,
            enabled: true,
            decoration: getDecoration('Year'),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomisedButton(
                width: 70,
                height: 50,
                text: 'Submit',
                onPressed: () async {
                  _formKey.currentState!.save();
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });

                    String semester = _formKey.currentState!.value['semester']
                        .toString()
                        .trim();
                    String year =
                        _formKey.currentState!.value['year'].toString().trim();
                    bool flag = true;
                    await FirebaseFirestore.instance
                        .collection('academic_calendar')
                        .where('semester', isEqualTo: semester)
                        .where('year', isEqualTo: year)
                        .get()
                        .then((value) async {
                      if (value.docs.isEmpty) {
                        flag = false;
                      }
                    });
                    if (flag) {
                      await FirebaseFirestore.instance
                          .collection('current_session')
                          .doc()
                          .set({
                        'semester': semester,
                        'year': year,
                      });
                    }
                    setState(() {
                      loading = false;
                      if (flag) {
                        status = 'completed';
                      } else {
                        status = 'failed';
                      }
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
