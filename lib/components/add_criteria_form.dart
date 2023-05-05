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

class AddCriteriaForm extends StatefulWidget {
  final refresh;

  const AddCriteriaForm({
    super.key,
    required this.refresh,
  });

  @override
  State<AddCriteriaForm> createState() => _AddCriteriaFormState();
}

class _AddCriteriaFormState extends State<AddCriteriaForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  var totalweeks = 0;
  int left_wt = 100;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            height: 1,
          ),
          Text(
            'Enter the semester',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          FormBuilderTextField(
            name: 'semester',
            validator: (value) => integerValidator(value, 'semester', 1, 2),
          ),
          const SizedBox(
            height: 1,
          ),
          Text(
            'Enter the year',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          FormBuilderTextField(
            name: 'year',
            validator: (value) => integerValidator(value, 'year', 2000, 2100),
          ),
          const SizedBox(
            height: 1,
          ),
          Text(
            'Enter the course',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 10,
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
            height: 1,
          ),
          Text(
            'Enter the number of weeks',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          FormBuilderTextField(
            name: 'Weeks',
            validator: (value) {
              var x = integerValidator(value, 'Weeks', 1, 20);
              if (x == null) {
                totalweeks = int.parse(value!);
              }
              return x;
            },
          ),
          const SizedBox(
            height: 1,
          ),
          Text(
            'Enter the number of weeks to consider',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          FormBuilderTextField(
            name: 'weeksToConsider',
            validator: (value) =>
                integerValidator(value, 'weeksToConsider', 1, totalweeks),
          ),
          const SizedBox(
            height: 1,
          ),
          Text(
            'Enter reports weightage',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          FormBuilderTextField(
              name: 'report',
              validator: (value) {
                var x = integerValidator(value, 'report', 0, left_wt);
                if (x == null) {
                  left_wt -= int.parse(value!);
                }
                return x;
              }),
          const SizedBox(
            height: 1,
          ),
          Text(
            'Enter regular weightage',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          FormBuilderTextField(
              name: 'regular',
              validator: (value) {
                var x = integerValidator(value, 'regular', 0, left_wt);
                if (x == null) {
                  left_wt -= int.parse(value!);
                }
                return x;
              }),
          const SizedBox(
            height: 1,
          ),
          Text(
            'Enter midterm supervisor weightage',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          FormBuilderTextField(
              name: 'midtermSupervisor',
              validator: (value) {
                var x =
                    integerValidator(value, 'midtermSupervisor', 0, left_wt);
                if (x == null) {
                  left_wt -= int.parse(value!);
                }
                return x;
              }),
          const SizedBox(
            height: 1,
          ),
          Text(
            'Enter midterm panel weightage',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          FormBuilderTextField(
              name: 'midtermPanel',
              validator: (value) {
                var x = integerValidator(value, 'midtermPanel', 0, left_wt);
                if (x == null) {
                  left_wt -= int.parse(value!);
                }
                return x;
              }),
          const SizedBox(
            height: 1,
          ),
          Text(
            'Enter endterm supervisor weightage',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
              // letterSpacing: 0.15,
            ),
          ),
          FormBuilderTextField(
              name: 'endtermSupervisor',
              validator: (value) {
                var x =
                    integerValidator(value, 'endtermSupervisor', 0, left_wt);
                if (x == null) {
                  left_wt -= int.parse(value!);
                }
                return x;
              }),
          const SizedBox(
            height: 1,
          ),
          Text(
            'Enter endterm panel weightage',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
              // letterSpacing: 0.15,
            ),
          ),
          FormBuilderTextField(
              name: 'endtermPanel',
              validator: (value) {
                var x = integerValidator(value, 'endtermPanel', 0, left_wt);
                if (x == null) {
                  left_wt -= int.parse(value!);
                }
                return x;
              }),
          const SizedBox(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                buttonText: 'Submit',
                onPressed: () {
                  _formKey.currentState?.save();
                  if (_formKey.currentState!.validate()) {
                    var formdata = _formKey.currentState?.value;
                    var alldata = <String, dynamic>{};
                    alldata.addEntries([
                      MapEntry('semester', formdata!['semester']),
                      MapEntry('year', formdata['year']),
                      MapEntry('course', formdata['course']),
                      MapEntry('weeksToConsider', formdata['weeksToConsider']),
                      MapEntry('numberOfWeeks', formdata['Weeks']),
                      MapEntry('regular', formdata['regular']),
                      MapEntry(
                          'midtermSupervisor', formdata['midtermSupervisor']),
                      MapEntry('midtermPanel', formdata['midtermPanel']),
                      MapEntry(
                          'endtermSupervisor', formdata['endtermSupervisor']),
                      MapEntry('endtermPanel', formdata['endtermPanel']),
                      MapEntry('report', formdata['report']),
                    ]);
                    FirebaseFirestore.instance
                        .collection('evaluation_criteria')
                        .add(alldata);
                    widget.refresh();

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
