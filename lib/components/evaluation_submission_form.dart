import 'package:casper/components/customised_button.dart';
import 'package:casper/comp/customised_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EvaluationSubmissionForm extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final student;

  EvaluationSubmissionForm({
    super.key,
    required this.student,
  });

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 500,
            child: CustomisedText(
              text: 'Enter marks for ${student.name}',
              color: Colors.black,
              fontSize: 23,
            ),
          ),
          FormBuilderTextField(
            name: 'studentMarks',
            cursorColor: Colors.black,
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              hintText: 'Marks',
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomisedButton(
                text: 'Upload',
                onPressed: () {},
                height: 50,
                width: 70,
              ),
              CustomisedButton(
                text: 'Cancel',
                onPressed: () => {
                  Navigator.pop(context),
                },
                height: 50,
                width: 70,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
