import 'dart:math';

import 'package:casper/utilites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/text_field.dart';
import 'package:casper/components/button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:multiselect/multiselect.dart';

class AddPanelForm extends StatefulWidget {
  final refresh;

  const AddPanelForm({
    super.key,
    required this.refresh,
  });

  @override
  State<AddPanelForm> createState() => _AddPanelFormState();
}

class _AddPanelFormState extends State<AddPanelForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  int number_of_evaluators = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    number_of_evaluators = 1;
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
          Text(
            'Enter the number of evaluators',
            style: SafeGoogleFont(
              'Ubuntu',
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color(0xff000000),
            ),
          ),
          FormBuilderTextField(
            name: 'number_of_evaluators',
            validator: FormBuilderValidators.integer(
                errorText: 'Enter a valid number'),
            initialValue: '1',
            onChanged: (value) {
              setState(() {
                number_of_evaluators = (int.tryParse(value!) == null
                    ? 0
                    : min(int.parse(value), 5));
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                for (int i = 0; i < number_of_evaluators; i++) ...[
                  Text(
                    'Evaluator ${i + 1} name: ',
                    style: SafeGoogleFont(
                      'Ubuntu',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff000000),
                    ),
                  ),
                  FormBuilderTextField(
                    name: 'evaluator$i',
                    validator: FormBuilderValidators.required(
                        errorText: 'Name cannot be empty'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ]
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
                onPressed: () {
                  _formKey.currentState?.save();
                  if (_formKey.currentState!.validate()) {
                    var names = List<String>.generate(
                        number_of_evaluators,
                        (index) =>
                            _formKey.currentState?.value['evaluator$index']);
                    var alldata = <String, dynamic>{};
                    alldata.addEntries([MapEntry('evaluator_names', names)]);
                    int newpanelid = 0;
                    FirebaseFirestore.instance
                        .collection('panels')
                        .get()
                        .then((value) {
                      // TODO: change                newpanelid = value.docs.length + 1;
                      newpanelid = value.docs.length + 2;
                      alldata.addEntries([
                        MapEntry('number_of_evaluators',
                            number_of_evaluators.toString()),
                        MapEntry('panel_id', newpanelid.toString()),
                        MapEntry(
                            'evaluator_ids',
                            List<String>.generate(number_of_evaluators,
                                (index) => index.toString())),
                      ]);
                      FirebaseFirestore.instance
                          .collection('panels')
                          .add(alldata);
                      widget.refresh();
                    });
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
