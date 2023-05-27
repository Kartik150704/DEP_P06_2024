import 'package:casper/components/customised_text.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/components/form_custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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
  int status = 0;
  String semester = '', year = '';
  final _formKey = GlobalKey<FormBuilderState>();

  var totalweeks = 0;
  int left_wt = 100;

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

  @override
  void initState() {
    super.initState();
    getSession();
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
    final verticalScrollbarController = ScrollController();

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
      return const FormCustomText(text: 'Panels added successfully');
    }

    return FormBuilder(
      key: _formKey,
      child: SizedBox(
        height: 700,
        child: Scrollbar(
          controller: verticalScrollbarController,
          thumbVisibility: true,
          trackVisibility: true,
          child: SingleChildScrollView(
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
                  validator: (value) =>
                      integerValidator(value, 'semester', 1, 2),
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
                  validator: (value) =>
                      integerValidator(value, 'year', 2000, 2100),
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
                  text: 'Enter the total number of weeks',
                  color: Colors.black,
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
                  cursorColor: Colors.black,
                  decoration: getDecoration('#Weeks'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const CustomisedText(
                  text: 'Enter the number of weeks to consider',
                  color: Colors.black,
                ),
                FormBuilderTextField(
                  name: 'weeksToConsider',
                  validator: (value) =>
                      integerValidator(value, 'weeksToConsider', 1, totalweeks),
                  cursorColor: Colors.black,
                  decoration: getDecoration('#Weeks To Consider'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const CustomisedText(
                  text: 'Enter the reports\' weightage',
                  color: Colors.black,
                ),
                FormBuilderTextField(
                  name: 'report',
                  validator: (value) {
                    var x = integerValidator(
                        value, 'report\'s weightage', 0, left_wt);
                    if (x == null) {
                      left_wt -= int.parse(value!);
                    }
                    return x;
                  },
                  cursorColor: Colors.black,
                  decoration: getDecoration('Report'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const CustomisedText(
                  text: 'Enter the regular evaluations\'s weightage',
                  color: Colors.black,
                ),
                FormBuilderTextField(
                  name: 'regular',
                  validator: (value) {
                    var x = integerValidator(
                        value, 'regular evaluation\'s weightage', 0, left_wt);
                    if (x == null) {
                      left_wt -= int.parse(value!);
                    }
                    return x;
                  },
                  cursorColor: Colors.black,
                  decoration: getDecoration('Regular'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const CustomisedText(
                  text: 'Enter the midterm supervisor\'s weightage',
                  color: Colors.black,
                ),
                FormBuilderTextField(
                  name: 'midtermSupervisor',
                  validator: (value) {
                    var x = integerValidator(
                        value, 'midterm supervisor\'s weightage', 0, left_wt);
                    if (x == null) {
                      left_wt -= int.parse(value!);
                    }
                    return x;
                  },
                  cursorColor: Colors.black,
                  decoration: getDecoration('Midterm Supervisor'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const CustomisedText(
                  text: 'Enter the midterm panel\'s weightage',
                  color: Colors.black,
                ),
                FormBuilderTextField(
                  name: 'midtermPanel',
                  validator: (value) {
                    var x = integerValidator(
                        value, 'midterm panel\'s weightageg', 0, left_wt);
                    if (x == null) {
                      left_wt -= int.parse(value!);
                    }
                    return x;
                  },
                  cursorColor: Colors.black,
                  decoration: getDecoration('Midterm Panel'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const CustomisedText(
                  text: 'Enter the endterm supervisor\'s weightage',
                  color: Colors.black,
                ),
                FormBuilderTextField(
                  name: 'endtermSupervisor',
                  validator: (value) {
                    var x = integerValidator(
                        value, 'endterm supervisor\'s weightage', 0, left_wt);
                    if (x == null) {
                      left_wt -= int.parse(value!);
                    }
                    return x;
                  },
                  cursorColor: Colors.black,
                  decoration: getDecoration('Endterm Supervisor'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const CustomisedText(
                  text: 'Enter the endterm panel\'s weightage',
                  color: Colors.black,
                ),
                FormBuilderTextField(
                  name: 'endtermPanel',
                  validator: (value) {
                    var x = integerValidator(
                        value, 'endterm panel\'s weightage', 0, left_wt);
                    if (x == null) {
                      left_wt -= int.parse(value!);
                    }
                    return x;
                  },
                  cursorColor: Colors.black,
                  decoration: getDecoration('Endterm Panel'),
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
                        {
                          _formKey.currentState?.save();
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              status = 1;
                            });

                            var formdata = _formKey.currentState?.value;
                            var alldata = <String, dynamic>{};
                            alldata.addEntries([
                              MapEntry('semester', formdata!['semester']),
                              MapEntry('year', formdata['year']),
                              MapEntry('course', formdata['course']),
                              MapEntry('weeksToConsider',
                                  formdata['weeksToConsider']),
                              MapEntry('numberOfWeeks', formdata['Weeks']),
                              MapEntry('regular', formdata['regular']),
                              MapEntry('midtermSupervisor',
                                  formdata['midtermSupervisor']),
                              MapEntry(
                                  'midtermPanel', formdata['midtermPanel']),
                              MapEntry('endtermSupervisor',
                                  formdata['endtermSupervisor']),
                              MapEntry(
                                  'endtermPanel', formdata['endtermPanel']),
                              MapEntry('report', formdata['report']),
                            ]);
                            FirebaseFirestore.instance
                                .collection('evaluation_criteria')
                                .add(alldata);
                            widget.refresh();

                            setState(() {
                              status = 2;
                            });
                          }
                        }
                      },
                    ),
                    CustomisedButton(
                      width: 70,
                      height: 50,
                      text: 'Cancel',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
