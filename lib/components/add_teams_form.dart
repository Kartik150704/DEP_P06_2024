import 'package:casper/components/customised_button.dart';
import 'package:casper/comp/customised_text.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddTeamsForm extends StatelessWidget {
  AddTeamsForm({
    super.key,
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
          const SizedBox(
            width: 500,
            child: CustomisedText(
              text: 'Enter the team IDs to be added (comma separated)',
              color: Colors.black,
              fontSize: 23,
            ),
          ),
          FormBuilderTextField(
            name: 'teamIds',
            cursorColor: Colors.black,
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              hintText: 'Example: 12, 34, 2',
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
                text: 'Add',
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
