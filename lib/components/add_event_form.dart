import 'package:casper/components/customised_text.dart';
import 'package:casper/components_new/customised_button.dart';
import 'package:casper/components_new/form_custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddEventForm extends StatefulWidget {
  final List<String> events;

  const AddEventForm({
    super.key,
    required this.events,
  });

  @override
  State<AddEventForm> createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
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
    } else if (!validSession) {
      return const FormCustomText(
        text: 'No session found',
      );
    } else if (status == 'completed') {
      return const FormCustomText(
        text: 'Event added successfully',
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
            enabled: false,
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
            enabled: false,
            decoration: getDecoration('Year'),
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
            height: 30,
          ),
          const CustomisedText(
            text: 'Select the type of event',
            color: Colors.black,
          ),
          const SizedBox(
            height: 5,
          ),
          FormBuilderRadioGroup(
            name: 'option',
            activeColor: Colors.black,
            validator: (value) =>
                (value == null) ? 'Please select an option' : null,
            options: const [
              // TODO: These are not static
              FormBuilderFieldOption(
                  value: 'week', child: FormCustomText(text: 'Week')),
              FormBuilderFieldOption(
                  value: 'MidTerm', child: FormCustomText(text: 'MidTerm')),
              FormBuilderFieldOption(
                  value: 'EndTerm', child: FormCustomText(text: 'EndTerm')),
            ],
            onChanged: (value) {
              setState(() {
                selectedEvent = value.toString();
              });
            },
          ),
          const SizedBox(
            height: 13,
          ),
          ((selectedEvent == 'week')
              ? Column(
                  children: [
                    const CustomisedText(
                        text: 'Enter the week number', color: Colors.black),
                    FormBuilderTextField(
                      name: 'week',
                      cursorColor: Colors.black,
                      decoration: getDecoration('#Week'),
                      validator: (value) =>
                          integerValidator(value, 'week', 1, 50),
                    ),
                  ],
                )
              : Container()),
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
                    String course = _formKey.currentState!.value['course']
                        .toString()
                        .trim();
                    String option = _formKey.currentState!.value['option']
                        .toString()
                        .trim();
                    String week =
                        _formKey.currentState!.value['week'].toString().trim();
                    await FirebaseFirestore.instance
                        .collection('academic_calendar')
                        .where('semester', isEqualTo: semester)
                        .where('year', isEqualTo: year)
                        .get()
                        .then((value) async {
                      if (value.docs.isEmpty) {
                      } else {
                        var doc = value.docs[0];
                        String eventName = '';
                        if (option == 'week') {
                          eventName = option + week;
                        } else {
                          eventName = option;
                        }
                        Timestamp eventStart =
                                doc['events'][eventName]['start'],
                            eventEnd = doc['events'][eventName]['end'];

                        await FirebaseFirestore.instance
                            .collection('released_events')
                            .where('semester', isEqualTo: semester)
                            .where('year', isEqualTo: year)
                            .where('course', isEqualTo: course)
                            .get()
                            .then((value) async {
                          if (value.docs.isEmpty) {
                          } else {
                            QueryDocumentSnapshot doc = value.docs[0];
                            List events;
                            // check if doc has key events
                            if (doc['events'] == null) {
                              events = [];
                            } else {
                              events = doc['events'].keys.toList();
                            }
                            if (events.contains(eventName)) {
                            } else {
                              Map eventMap;
                              if (doc['events'] == null) {
                                eventMap = {};
                              } else {
                                eventMap = doc['events'];
                              }
                              eventMap[eventName] = {
                                'start': eventStart
                                    .toDate()
                                    .toString()
                                    .split(' ')[0]
                                    .split('-')
                                    .reversed
                                    .join('/')
                                    .trim(),
                                'end': eventEnd
                                    .toDate()
                                    .toString()
                                    .split(' ')[0]
                                    .split('-')
                                    .reversed
                                    .join('/')
                                    .trim(),
                              };

                              await FirebaseFirestore.instance
                                  .collection('released_events')
                                  .doc(doc.id)
                                  .update({
                                'events': eventMap,
                              });
                            }
                          }
                        });
                      }
                    });

                    setState(() {
                      loading = false;
                      status = 'completed';
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
